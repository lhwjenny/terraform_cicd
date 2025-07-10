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

variable "interface_endpoints" {
  type        = set(string)
  description = "만들고 싶은 모든 인터페이스 엔드포인트 서비스명"
  default     = []
}

variable "services_with_service_sg" {
  type        = set(string)
  description = "서비스 sg를 붙일 서비스명 (interface_endpoints의 부분집합)"
  default     = []
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
  default = {}
}
