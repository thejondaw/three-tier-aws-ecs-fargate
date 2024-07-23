# ==================================================== #

# Configure AWS Provider
variable "region" {
  description = "Please provide a region information"
  type        = string
  default     = ""
}

# Variable for Backend
variable "bucket" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
  default     = "mrjondaw"
}

# ==================================================== #

# Variable for Secret Manafer of DB
variable "secret_manager_db_arn" {
  description = "ARN of the Secret Manager DB secret"
  type        = string
}

# ================== VPC Variables =================== #

# Variable of "VPC":
variable "vpc_id" {
  description = "ID of VPC"
  type        = string
}

# Variable of "Public Subnet #1 (WEB)":
variable "subnet_web_id" {
  description = "ID of Public Subnet #1 (WEB)"
  type        = string
}

# Variable of "Public Subnet #2 (ALB)":
variable "subnet_alb_id" {
  description = "ID of Public Subnet #2 (ALB)"
  type        = string
}

# Variable of "Private Subnet #3 (API)":
variable "subnet_api_id" {
  description = "ID of Private Subnet #3 (API)"
  type        = string
}

# ==================================================== #