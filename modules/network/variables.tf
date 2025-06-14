variable "vpc_id" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "tag" {
  type    = string
  default = "Terraform"
}
