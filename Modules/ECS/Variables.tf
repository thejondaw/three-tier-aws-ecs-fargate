# ============== Variables of ECS Module ============= #

# Variable for AWS Region
variable "region" {
  description = "AWS Region"
  type        = string
}

# ============= CIDR for VPC and Subnets ============= #

# Variable for CIDR Block of VPC
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

# Variable for CIDR Block of WEB Subnet #1 - Public
variable "subnet_web_1_cidr" {
  description = "CIDR Block for WEB Subnet #1 - Public"
}

# Variable for CIDR Block of WEB Subnet #2 - Public
variable "subnet_web_2_cidr" {
  description = "CIDR Block for WEB Subnet #2 - Public"
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


