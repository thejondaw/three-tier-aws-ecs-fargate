# ==================================================== #
# ================= CIDR for Subnets ================= #
# ==================================================== #

variable "subnet_1_cidr" {
  description = "CIDR block for subnet 1 (WEB)"
  type        = string
}

variable "subnet_2_cidr" {
  description = "CIDR block for subnet 2 (ALB)"
  type        = string
}

variable "subnet_3_cidr" {
  description = "CIDR block for subnet 3 (API)"
  type        = string
}

variable "subnet_4_cidr" {
  description = "CIDR block for subnet 4 (DATABASE)"
  type        = string
}

# ==================================================== #