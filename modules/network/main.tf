provider "aws" {
  region = var.region
}

# 1. VPC 생성
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-vpc"
  })
}

# 2. Subnet 2개 생성 (AZ 분산)
resource "aws_subnet" "this" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-subnet-${count.index}"
  })
}

data "aws_availability_zones" "available" {}

# 3. 인터넷 게이트웨이 및 라우팅 (엔드포인트용으로 필수는 아님, 예시 포함)
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-igw"
  })
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-route-table"
  })
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "this" {
  count          = 2
  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.this.id
}

# 4. 서비스 네임 매핑
locals {
  service_name_map = {
    ssm        = "com.amazonaws.${var.region}.ssm"
    sts        = "com.amazonaws.${var.region}.sts"
    ec2        = "com.amazonaws.${var.region}.ec2"
    monitoring = "com.amazonaws.${var.region}.monitoring"
    athena     = "com.amazonaws.${var.region}.athena"
    kms        = "com.amazonaws.${var.region}.kms"
  }
}

# 5. Default Security Group
resource "aws_security_group" "default_endpoint_sg" {
  name        = "${var.name_prefix}-default-endpoint-sg"
  description = "Default SG for all VPC Endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.default_sg_ingress_cidrs
    description = "Allow HTTPS from trusted sources"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-default-endpoint-sg"
  })
}

# 6. Athena 전용 SG
resource "aws_security_group" "service_athena_sg" {
  count       = contains(var.endpoint_services, var.athena_service_name) ? 1 : 0
  name        = "${var.name_prefix}-athena-endpoint-sg"
  description = "Service-specific SG for Athena VPC Endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.service_sg_ingress_cidrs
    description = "Allow HTTPS from trusted sources"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-athena-endpoint-sg"
  })
}

## KMS
resource "aws_security_group" "service_kms_sg" {
  count       = contains(var.endpoint_services, var.kms_service_name) ? 1 : 0
  name        = "${var.name_prefix}-kms-endpoint-sg"
  description = "Service-specific SG for KMS VPC Endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.kms_service_sg_ingress_cidrs
    description = "Allow HTTPS from trusted sources"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-kms-endpoint-sg"
  })
}

## EC2
resource "aws_security_group" "service_ec2_sg" {
  name        = "${var.name_prefix}-ec2-endpoint-service-sg"
  description = "Service SG for EC2 VPC Endpoint"
  vpc_id      = module.network.vpc_id # 또는 직접 vpc_id 참조

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24"] # 원하는 CIDR로 변경
    description = "Allow HTTPS from trusted sources"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.name_prefix}-ec2-endpoint-service-sg"
  }
}

# 7. VPC Endpoint (for_each)
resource "aws_vpc_endpoint" "this" {
  for_each = var.endpoint_services

  vpc_id             = aws_vpc.this.id
  service_name       = local.service_name_map[each.value]
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [for s in aws_subnet.this : s.id]
  private_dns_enabled = var.private_dns_enabled

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-${each.value}-endpoint"
  })
}

# 8. SG Association: Default (모든 서비스)
resource "aws_vpc_endpoint_security_group_association" "default" {
  for_each = var.endpoint_services

  vpc_endpoint_id   = aws_vpc_endpoint.this[each.value].id
  security_group_id = aws_security_group.default_endpoint_sg.id
}

# 9. SG Association: Athena만 추가
resource "aws_vpc_endpoint_security_group_association" "athena" {
  for_each = {
    for svc in var.endpoint_services : svc => svc
    if svc == var.athena_service_name
  }

  vpc_endpoint_id   = aws_vpc_endpoint.this[each.key].id
  security_group_id = aws_security_group.service_athena_sg[0].id
}

resource "aws_vpc_endpoint_security_group_association" "kms" {
  for_each = {
    for svc in var.endpoint_services : svc => svc
    if svc == var.kms_service_name
  }

  vpc_endpoint_id   = aws_vpc_endpoint.this[each.key].id
  security_group_id = aws_security_group.service_kms_sg[0].id
}

resource "aws_vpc_endpoint_security_group_association" "ec2_service" {
  vpc_endpoint_id   = aws_vpc_endpoint.this["ec2"].id # 또는 aws_vpc_endpoint.this["ec2"].id
  security_group_id = aws_security_group.service_ec2_sg.id
}