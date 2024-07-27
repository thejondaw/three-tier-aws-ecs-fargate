# ============== Variables of RDS Module ============= #

# Variable for AWS Region
variable "region" {
  description = "AWS Region"
  type        = string
}

# =================  VPC and Subnets ================= #

# Variable for CIDR Block of VPC
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

# Variable for CIDR Block of API Subnet #1 - Private
variable "subnet_api_1_cidr" {
  description = "CIDR Block for API Subnet #1 - Private"
}

# Variable for CIDR Block of API Subnet #2 - Private
variable "subnet_api_2_cidr" {
  description = "CIDR Block for API Subnet #2 - Private"
}

# Variable for CIDR Block of DB Subnet #1 - Private
variable "subnet_db_1_cidr" {
  description = "CIDR Block for DB Subnet #1 - Private"
}

# Variable for CIDR Block of DB Subnet #2 - Private
variable "subnet_db_2_cidr" {
  description = "CIDR Block for DB Subnet #2 - Private"
}

# ==================================================== #