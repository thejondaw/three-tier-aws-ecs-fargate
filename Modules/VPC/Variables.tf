# --- --- --- --- --- --- --- --- --- --- #

# Configure AWS Provider
variable "region" {
  description = "Please provide a region information"
  type        = string
  default     = ""
}

# --- --- --- --- --- --- --- --- --- --- #

# Variable for Backend
variable "bucket" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
  default     = "mrjondaw"
}

# --- --- --- --- --- --- --- --- --- --- #

# CIDR Block for VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# CIDR Block for Subnet #1 (Public)
variable "subnet_1_cidr" {
  default = "10.0.1.0/24"
}

# CIDR Block for Subnet #2 (Public)
variable "subnet_2_cidr" {
  default = "10.0.2.0/24"
}

# CIDR Block for Subnet #3 (Private)
variable "subnet_3_cidr" {
  default = "192.168.3.0/24"
}

# CIDR Block for Subnet #4 (Private)
variable "subnet_4_cidr" {
  default = "192.168.4.0/24"
}

# --- --- --- --- --- --- --- --- --- --- #