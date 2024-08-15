# ============== VARIABLES OF RDS Module ============= #

# Variable for "AWS Region"
variable "region" {
  description = "AWS Region"
  type        = string
}

# ==================  VPC & SUBNETS ================== #

# Variable for "CIDR Block" of "VPC"
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
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

# ============== VARIABLES OF DATABASE =============== #

# Variable for "DB Name"
variable "db_name" {
  description = "Name of the database"
  type        = string
}

# Variable for "DB Username"
variable "db_username" {
  description = "Username for the database"
  type        = string
}

# Variable for "DB Password"
variable "db_password" {
  description = "Password for the database"
  type        = string
}

# Variable for "Secret Manager" Name
variable "secret_manager_name" {
  description = "Name of the Aurora secret in Secrets Manager"
  type        = string
}
