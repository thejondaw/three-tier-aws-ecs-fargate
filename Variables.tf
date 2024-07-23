# ==================================================== #
# ================= CIDR for Subnets ================= #
# ==================================================== #

# # Variable for CIDR Block of Public Subnet #1:
# variable "subnet_1_cidr" {
#   description = "CIDR block for subnet 1 (WEB)"
#   type        = string
# }

# # Variable for CIDR Block of Public Subnet #2:
# variable "subnet_2_cidr" {
#   description = "CIDR block for subnet 2 (ALB)"
#   type        = string
# }

# # Variable for CIDR Block of Private Subnet #3:
# variable "subnet_3_cidr" {
#   description = "CIDR block for subnet 3 (API)"
#   type        = string
# }

# # Variable for CIDR Block of Private Subnet #4:
# variable "subnet_4_cidr" {
#   description = "CIDR block for subnet 4 (DATABASE)"
#   type        = string
# }

# ==================================================== #
# ============= CIDR for VPC and Subnets ============= #
# ==================================================== #

# CIDR Block for "VPC":
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# CIDR Block for "Public Subnet #1":
variable "subnet_1_cidr" {
  default = "10.0.1.0/24"
}

# CIDR Block for "Public Subnet #2":
variable "subnet_2_cidr" {
  default = "10.0.2.0/24"
}

# CIDR Block for "Private Subnet #3":
variable "subnet_3_cidr" {
  default = "192.168.3.0/24"
}

# CIDR Block for "Private Subnet #4":
variable "subnet_4_cidr" {
  default = "192.168.4.0/24"
}

# ==================================================== #