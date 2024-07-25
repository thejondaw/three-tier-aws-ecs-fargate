# ==================================================== #
# ============== Variables of VPC Module ============= #
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

# ============= CIDR for VPC and Subnets ============= #

# Variable for CIDR Block of "VPC":
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

# Variable for CIDR Block of "Public Subnet #1 (WEB)":
variable "subnet_web_cidr" {
  description = "CIDR Block for Public Subnet #1 (WEB)"
}

# Variable for CIDR Block of "Public Subnet #2 (ALB)":
variable "subnet_alb_cidr" {
  description = "CIDR Block for Public Subnet #2 (ALB)"
}

# Variable for CIDR Block of "Private Subnet #3 (API)":
variable "subnet_api_cidr" {
  description = "CIDR Block for Private Subnet #3 (API)"
}

# Variable for CIDR Block of "Private Subnet #4 (DB)":
variable "subnet_db_cidr" {
  description = "CIDR Block for Private Subnet #4 (DB)"
}

# ==================================================== #

# Variable for "ID" of "Private Subnet #3 (API)":
variable "subnet_api_id" {
}

# Variable for "ID" of "Private Subnet #4 (DB)":
variable "subnet_db_id" {
}
