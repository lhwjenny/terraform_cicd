variable "aws_region" {
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.100.1.0/24", "10.100.2.0/24"]
}

variable "services_with_service_sg" {
  default = ["athena"]
}

variable "service_sg_ingress_rules_map" {
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
