variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
}

variable "tag" {
  type    = string
  default = "Terraform"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.tag}-VPC"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}