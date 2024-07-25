# ==================================================== #
# ============== Variables of RDS Module ============= #
# ==================================================== #

# Variable for "AWS Region":
variable "region" {
  description = "AWS Region"
  type        = string
}

# =================  VPC and Subnets ================= #

# Variable for CIDR Block of "VPC":
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

# ==================================================== #