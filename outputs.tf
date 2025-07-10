output "athena_endpoint_id" {
  value = module.network.athena_endpoint_id
}

output "service_sg_ids" {
  value = module.network.service_sg_ids
}

output "default_endpoint_sg_id" {
  value = module.network.default_endpoint_sg_id
}
