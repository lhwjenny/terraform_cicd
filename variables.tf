variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.100.1.0/24", "10.100.2.0/24"]
}

variable "services_with_service_sg" {
  type    = list(string)
  default = ["athena"]
}

variable "interface_endpoints" {
  type        = set(string)
  description = "만들고 싶은 모든 인터페이스 엔드포인트 서비스명"
}

variable "service_sg_ingress_rules_map" {
  type = map(list(object({
    description      = string
    prefix_list_ids  = list(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
  })))
  default = {
    athena = [
      {
        description      = "Allow HTTPS"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["10.100.0.0/16"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
      },
      {
        description      = "Allow TCP 444"
        from_port        = 444
        to_port          = 444
        protocol         = "tcp"
        cidr_blocks      = ["10.100.0.0/16"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
      }
    ]
  }
}
