output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = [for s in aws_subnet.this : s.id]
}

output "default_endpoint_sg_id" {
  value = aws_security_group.default_endpoint_sg.id
}

output "service_athena_sg_id" {
  value = length(aws_security_group.service_athena_sg) > 0 ? aws_security_group.service_athena_sg[0].id : null
}

output "vpc_endpoint_ids" {
  value = { for k, v in aws_vpc_endpoint.this : k => v.id }
}
