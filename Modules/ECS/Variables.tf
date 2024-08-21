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

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# Variable for "Secret Manager" Name
variable "secret_manager_name" {
  description = "Name of Secrets Manager"
  type        = string
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# Variable for "ECR Repository" name for "API Application"
variable "ecr_repository_name_api" {
  description = "Name of the ECR Repository for API"
  type        = string
}

# Variable for "ECR Repository" name for "WEB Application"
variable "ecr_repository_name_web" {
  description = "Name of the ECR Repository for WEB"
  type        = string
}

# Variable for Docker image tag
variable "docker_image_tag" {
  description = "Tag for Docker images"
  type        = string
  default     = "latest"
}