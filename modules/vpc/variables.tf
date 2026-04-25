# VPC Module - variables.tf

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
