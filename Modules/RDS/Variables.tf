# ==================================================== #
# ============== Variables of RDS Module ============= #
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

# Variable for CIDR Block of "Private Subnet #3 (API)":
variable "subnet_api_cidr" {
  description = "CIDR Block for Private Subnet #3 (API)"
  type = string
}

# Variable for CIDR Block of "Private Subnet #4 (DB)":
variable "subnet_db_cidr" {
  description = "CIDR Block for Private Subnet #4 (DB)"
  type = string
}

# ==================================================== #