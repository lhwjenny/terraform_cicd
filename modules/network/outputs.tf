output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "default_endpoint_sg_id" {
  value = aws_security_group.default_endpoint_sg.id
}

output "service_sg_ids" {
  value = { for svc, sg in aws_security_group.service_sg : svc => sg.id }
}

output "interface_endpoint_ids" {
  value = { for svc, ep in aws_vpc_endpoint.interface_endpoints : svc => ep.id }
}
