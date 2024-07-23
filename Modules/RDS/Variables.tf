# ==================================================== #

# Variable for "AWS Region":
variable "region" {
  description = "AWS Region"
  type        = string
}

# Variable for "S3 Bucket":
variable "bucket" {
  description = "Name of S3 bucket"
  type        = string
}

# ==================================================== #

# Variables for Subnets:
variable "subnet_ids" {
  description = "List of subnet IDs to be used in RDS Subnet Group"
  type        = list(string)
}

# Variable of "Public Subnet #3 (API)":
variable "subnet_api_id" {
  description = "ID of Public Subnet #2 (API)"
  type        = string
}

# Variable of "Private Subnet #4 (DB)":
variable "subnet_db_id" {
  description = "ID of Private Subnet #3 (DB)"
  type        = string
}

# ==================================================== #