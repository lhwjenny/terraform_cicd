# terraform {
#   required_version = ">= 1.0.5"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 3.49.0"
#     }
#   }
# }

provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"

  # 아래 변수들은 modules/network/variables.tf에 정의된 변수명에 맞게 전달해야 합니다.
  region                   = var.region
  name_prefix              = var.name_prefix
  default_sg_ingress_cidrs = var.default_sg_ingress_cidrs
  service_sg_ingress_cidrs = var.service_sg_ingress_cidrs
  private_dns_enabled      = var.private_dns_enabled
  common_tags              = var.common_tags
  endpoint_services        = var.endpoint_services
  athena_service_name      = var.athena_service_name
  kms_service_name         = var.kms_service_name
  kms_service_sg_ingress_cidrs  = var.kms_service_sg_ingress_cidrs
}
