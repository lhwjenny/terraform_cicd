output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "default_endpoint_sg_id" {
  value = module.network.default_endpoint_sg_id
}

output "service_athena_sg_id" {
  value = module.network.service_athena_sg_id
}

output "vpc_endpoint_ids" {
  value = module.network.vpc_endpoint_ids
}

output "service_kms_sg_id" {
  value = module.network.service_kms_sg_id
}
