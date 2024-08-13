# ================ VARIABLES OF ROOT ================= #

# Variable for AWS RegionVariable for AWS Region
variable "region_rv" {
  description = "Please provide a region information"
  type        = string
}

# ========== CIDR BLOCK FOR VPC & SUBNETS ============ #

# Variable for "CIDR Block" of "VPC"
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
}

# Variable for "CIDR Block" of "WEB Subnet #1" "Public"
variable "subnet_web_1_cidr" {
  description = "CIDR Block for WEB Subnet #1 - Public"
  type        = string
}

# Variable for "CIDR Block" of "WEB Subnet #2" "Public"
variable "subnet_web_2_cidr" {
  description = "CIDR Block for WEB Subnet #2 - Public"
  type        = string
}

# Variable for "CIDR Block" of "DB Subnet #1" "Private"
variable "subnet_db_1_cidr" {
  description = "CIDR Block for DB Subnet #1 - Private"
  type        = string
}

# Variable for "CIDR Block" of "DB Subnet #2" "Private"
variable "subnet_db_2_cidr" {
  description = "CIDR Block for DB Subnet #2 - Private"
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
variable "aurora_secret_name" {
  description = "Name of the Aurora secret in Secrets Manager"
  type        = string
}
