# ==================================================== #

# Variable for AWS Provider - Region:
variable "region" {
  description = "Please provide a region information"
  type        = string
  default     = ""
}

# ==================================================== #

# Variable for S3 Bucket - Backend:
variable "bucket" {
  description = "Name of S3 bucket to store Terraform state"
  type        = string
  default     = ""
}

# ==================================================== #

# Variables for Subnets:
variable "subnet_ids" {
  description = "List of subnet IDs to be used in RDS Subnet Group"
  type        = list(string)
}

# CIDR Block for "Private Subnet #3":
variable "subnet_3_cidr" {
  default = "192.168.3.0/24"
}

# CIDR Block for "Private Subnet #4":
variable "subnet_4_cidr" {
  default = "192.168.4.0/24"
}

# ==================================================== #