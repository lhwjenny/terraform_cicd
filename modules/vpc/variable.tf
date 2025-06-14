variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "tag" {
  type    = string
  default = "Terraform"
}
