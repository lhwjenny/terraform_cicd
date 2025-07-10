output "service_sg_ids" {
  value = module.network.service_sg_ids
}

output "default_endpoint_sg_id" {
  value = module.network.default_endpoint_sg_id
}
