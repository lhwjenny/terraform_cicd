output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "security_group_id" {
  value = aws_security_group.default_sg.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
