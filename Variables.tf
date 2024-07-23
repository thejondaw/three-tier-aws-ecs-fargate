# ==================================================== #
# ================= CIDR for Subnets ================= #
# ==================================================== #

# Variable for CIDR Block of Public Subnet #1:
variable "subnet_1_cidr" {
  description = "CIDR block for subnet 1 (WEB)"
  type        = string
}

# Variable for CIDR Block of Public Subnet #2:
variable "subnet_2_cidr" {
  description = "CIDR block for subnet 2 (ALB)"
  type        = string
}

# Variable for CIDR Block of Private Subnet #3:
variable "subnet_3_cidr" {
  description = "CIDR block for subnet 3 (API)"
  type        = string
}

# Variable for CIDR Block of Private Subnet #4:
variable "subnet_4_cidr" {
  description = "CIDR block for subnet 4 (DATABASE)"
  type        = string
}

# ==================================================== #