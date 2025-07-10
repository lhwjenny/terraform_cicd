output "athena_endpoint_id" {
  value = aws_vpc_endpoint.athena.id
}

output "service_sg_ids" {
  value = {
    for svc, sg in aws_security_group.service_sg : svc => sg.id
  }
}

output "default_endpoint_sg_id" {
  value = aws_security_group.default_endpoint_sg.id
}
