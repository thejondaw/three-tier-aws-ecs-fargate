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

# Variable for Subnets:
variable "subnet_ids" {
  description = "List of subnet IDs to be used in RDS Subnet Group"
  type        = list(string)
}

# ==================================================== #