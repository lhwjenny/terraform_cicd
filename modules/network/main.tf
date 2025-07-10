resource "aws_security_group" "default_endpoint_sg" {
  name   = "demo-default-endpoint-sg"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-default-endpoint-sg"
  }
}

resource "aws_security_group" "service_sg" {
  for_each = { for svc in var.services_with_service_sg : svc => svc }

  name        = "demo-${each.key}-endpoint/service-sg-1"
  description = "Service SG for ${each.key}"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = lookup(var.service_sg_ingress_rules_map, each.key, [])
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      ipv6_cidr_blocks= ingress.value.ipv6_cidr_blocks
      prefix_list_ids = ingress.value.prefix_list_ids
      security_groups = ingress.value.security_groups
      description     = ingress.value.description
    }
  }

  tags = {
    Name = "demo-${each.key}-endpoint/service-sg-1"
  }
}

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = var.interface_endpoints

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.${each.key}"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.public[*].id

  security_group_ids = compact([
    aws_security_group.default_endpoint_sg.id,
    try(aws_security_group.service_sg[each.key].id, null)
  ])

  private_dns_enabled = true

  tags = {
    Name = "demo-${each.key}-endpoint"
  }
}
