variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "demo"
}

variable "default_sg_ingress_cidrs" {
  description = "CIDR blocks for default SG ingress"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "service_sg_ingress_cidrs" {
  description = "CIDR blocks for Athena service SG ingress"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_dns_enabled" {
  description = "Enable Private DNS for VPC Endpoint"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "endpoint_services" {
  description = "Set of endpoint service names (ex: ssm, sts, ec2, monitoring, athena)"
  type        = set(string)
  default     = ["ssm", "sts", "ec2", "monitoring", "athena", "kms"]
}

variable "athena_service_name" {
  description = "Service name for Athena"
  type        = string
  default     = "athena"
}

variable "kms_service_name" {
  description = "Service name for KMS"
  type        = string
  default     = "kms"
}

variable "kms_service_sg_ingress_cidrs" {
  description = "CIDR blocks for KMS service SG ingress"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}