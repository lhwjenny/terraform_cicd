variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "tag" {
  type    = string
  default = "Terraform"
}
