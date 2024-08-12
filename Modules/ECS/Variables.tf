# ============== VARIABLES OF ECS MODULE ============= #

# Variable for "AWS Region"
variable "region" {
  description = "AWS Region"
  type        = string
}

# ============== CIDR FOR VPC & Subnets ============== #

# Variable for "CIDR Block" of "VPC"
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

# Variable for "CIDR Block" of "WEB Subnet #1" "Public"
variable "subnet_web_1_cidr" {
  description = "CIDR Block for WEB Subnet #1 - Public"
}

# Variable for "CIDR Block" of "WEB Subnet #2" "Public"
variable "subnet_web_2_cidr" {
  description = "CIDR Block for WEB Subnet #2 - Public"
}

# Variable for "CIDR Block" of "DB Subnet #1" "Private"
variable "subnet_db_1_cidr" {
  description = "CIDR Block for DB Subnet #1 - Private"
}

# Variable for "CIDR Block" of "DB Subnet #2" "Private"
variable "subnet_db_2_cidr" {
  description = "CIDR Block for DB Subnet #2 - Private"
}

# Variable for "Secret Manager" Name
variable "aurora_secret_name" {
  description = "Name of the Aurora secret in Secrets Manager"
  type        = string
}
