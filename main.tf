provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  tag      = "Terraform"
}

module "network" {
  source             = "./modules/network"
  vpc_id             = module.vpc.vpc_id
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  tag                = "Terraform"
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.network.private_subnet_ids[0]
  security_group_id = module.network.security_group_id
  tag               = "Terraform"
}
