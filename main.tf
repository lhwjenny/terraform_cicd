provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"

  aws_region                    = var.aws_region
  vpc_cidr                      = var.vpc_cidr
  public_subnet_cidrs           = var.public_subnet_cidrs
  services_with_service_sg      = var.services_with_service_sg
  service_sg_ingress_rules_map  = var.service_sg_ingress_rules_map
}
