# ==================================================== #
# ============== Variables of ECS Module ============= #
# ==================================================== #

# Variable for "AWS Region":
variable "region" {
  description = "AWS Region"
  type        = string
  default     = var.region
}

# Variable for "S3 Bucket":
variable "bucket" {
  description = "Name of S3 bucket"
  type        = string
  default     = var.bucket
}

# ==================================================== #

# Variable for "Secret Manafer" of "DB":
variable "secret_manager_db" {
  description = "ARN of the Secret Manager DB secret"
  type        = string
}

# ============= CIDR for VPC and Subnets ============= #

# Variable for CIDR Block of "VPC":
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = var.vpc_cidr
}

# Variable for CIDR Block of "Public Subnet #1 (WEB)":
variable "subnet_web_cidr" {
  description = "CIDR Block for Public Subnet #1 (WEB)"
  default     = var.subnet_web_cidr
}

# Variable for CIDR Block of "Public Subnet #2 (ALB)":
variable "subnet_alb_cidr" {
  description = "CIDR Block for Public Subnet #2 (ALB)"
  default     = var.subnet_alb_cidr
}

# Variable for CIDR Block of "Private Subnet #3 (API)":
variable "subnet_api_cidr" {
  description = "CIDR Block for Private Subnet #3 (API)"
  default     = var.subnet_api_cidr
}

# ==================================================== #