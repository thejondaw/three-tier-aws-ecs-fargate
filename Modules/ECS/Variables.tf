# ==================================================== #

# Configure AWS Provider
variable "region" {
  description = "Please provide a region information"
  type        = string
  default     = ""
}

# ==================================================== #

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

# ==================================================== #
# ================== VPC Variables =================== #
# ==================================================== #

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_web_id" {
  description = "ID of the WEB (Public) subnet"
  type        = string
}

variable "subnet_alb_id" {
  description = "ID of the ALB (Public) subnet"
  type        = string
}

variable "subnet_api_id" {
  description = "ID of the API (Private) subnet"
  type        = string
}

# ==================================================== #