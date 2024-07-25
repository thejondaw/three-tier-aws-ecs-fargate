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

# =================  VPC and Subnets ================= #

# Variable for CIDR Block of "VPC":
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

# Variable for "ID" of "Private Subnet #3 (API)":
variable "subnet_api_id" {
  # description = "ID of API subnet"
  # type        = string
}

# Variable for "ID" of "Private Subnet #4 (DB)":
variable "subnet_db_id" {
  # description = "ID of DB subnet"
  # type        = string
}

# ==================================================== #