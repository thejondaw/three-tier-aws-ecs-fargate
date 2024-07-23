# ==================================================== #

# # Variable for "AWS Provider" - Region:
# variable "region" {
#   description = "Please provide a region information"
#   type        = string
#   default     = ""
# }

# # Variable for "S3 Bucket" - Backend:
# variable "bucket" {
#   description = "Name of S3 bucket to store Terraform state"
#   type        = string
#   default     = ""
# }

# ============= CIDR for VPC and Subnets ============= #

# CIDR Block for "VPC":
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

# CIDR Block for "Public Subnet #1":
variable "subnet_web_cidr" {
  description = "CIDR Block for Public Subnet #1 (WEB)"
  default     = "10.0.1.0/24"
}

# CIDR Block for "Public Subnet #2":
variable "subnet_alb_cidr" {
  description = "CIDR Block for Public Subnet #2 (ALB)"
  default     = "10.0.2.0/24"
}

# CIDR Block for "Private Subnet #3":
variable "subnet_api_cidr" {
  description = "CIDR Block for Private Subnet #3 (API)"
  default     = "192.168.3.0/24"
}

# CIDR Block for "Private Subnet #4":
variable "subnet_db_cidr" {
  description = "CIDR Block for Private Subnet #4 (DB)"
  default     = "192.168.4.0/24"
}

# =============== Variables of Subnets =============== #

# # Variable of "VPC":
# variable "vpc_id" {
#   description = "ID of VPC"
#   type        = string
# }

# # Variable of "Public Subnet #1 (WEB)":
# variable "subnet_web_id" {
#   description = "ID of Public Subnet #1 (WEB)"
#   type        = string
# }

# # Variable of "Public Subnet #2 (ALB)":
# variable "subnet_alb_id" {
#   description = "ID of Public Subnet #2 (ALB)"
#   type        = string
# }

# # Variable of "Private Subnet #3 (API)":
# variable "subnet_api_id" {
#   description = "ID of Private Subnet #3 (API)"
#   type        = string
# }

# # Variable of "Private Subnet #4 (DB)":
# variable "subnet_db_id" {
#   description = "ID of Private Subnet #4 (DB)"
#   type        = string
# }

# ==================================================== #