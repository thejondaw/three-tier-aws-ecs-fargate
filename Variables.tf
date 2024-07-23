# ==================================================== #

# Variable for "AWS Provider" - Region:
variable "region" {
  description = "Please provide a region information"
  type        = string
}
# Variable for "S3 Bucket" - Backend:
variable "bucket" {
  description = "Name of S3 bucket to store Terraform state"
  type        = string
}

# ============= CIDR for VPC and Subnets ============= #

# CIDR Block for "VPC":
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/8"
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
  default     = "172.16.0.0/24"
}

# CIDR Block for "Private Subnet #4":
variable "subnet_db_cidr" {
  description = "CIDR Block for Private Subnet #4 (DB)"
  default     = "172.16.1.0/24"
}

// Advantages of this IP range distribution:
//
// 1. Clear visual separation of Public and Private subnets.
// 2. Simplifies Security Policy creation and traffic filtering.
// 3. Facilitates integration with existing corporate Networks.
// 4. Allows for easy Network scaling in the future.

# ==================================================== #