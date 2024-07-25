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

variable "subnet_api" {
  description = "API subnet resource"
}

variable "subnet_db" {
  description = "DB subnet resource"
}

# ==================================================== #