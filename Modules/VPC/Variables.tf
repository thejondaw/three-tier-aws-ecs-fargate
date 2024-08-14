# ============== VARIABLES OF VPC MODULE ============= #

# Variable for "AWS Region"
variable "region" {
  description = "Please provide a Region information"
  type        = string
}

# ============== CIDR FOR VPC & SUBNETS ============== #

# Variable for "CIDR Block" of "VPC"
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# Variable for "CIDR Block" of "Public Subnet #1"
variable "subnet_web_1_cidr" {
  description = "CIDR Block for WEB Subnet #1 - Public"
  type        = string
}

# Variable for "CIDR Block" of "Public Subnet #2"
variable "subnet_web_2_cidr" {
  description = "CIDR Block for WEB Subnet #2 - Public"
  type        = string
}

# Variable for "CIDR Block" of "Public Subnet #3"
variable "subnet_web_3_cidr" {
  description = "CIDR Block for WEB Subnet #3 - Public"
  type        = string
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# Variable for "CIDR Block" of "Private Subnet #1"
variable "subnet_db_1_cidr" {
  description = "CIDR Block for DB Subnet #1 - Private"
  type        = string
}

# Variable for "CIDR Block" of "Private Subnet #2"
variable "subnet_db_2_cidr" {
  description = "CIDR Block for DB Subnet #2 - Private"
  type        = string
}

# Variable for "CIDR Block" of "Private Subnet #3"
variable "subnet_db_3_cidr" {
  description = "CIDR Block for DB Subnet #3 - Private"
  type        = string
}
