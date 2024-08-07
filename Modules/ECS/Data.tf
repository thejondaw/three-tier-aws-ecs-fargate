# ===================== VPC DATA ===================== #

# Fetch "VPC" info
data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Fetch "WEB Subnet #1" "Public" info:
data "aws_subnet" "web_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_web_1_cidr
}

# Fetch "WEB Subnet #2" "Public" info
data "aws_subnet" "web_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_web_2_cidr
}

# Fetch "API Subnet #1" "Private" info
data "aws_subnet" "api_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_api_1_cidr
}

# Fetch "API Subnet #2" "Private" info
data "aws_subnet" "api_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_api_2_cidr
}

# Fetch "DB Subnet #1" "Private" info
data "aws_subnet" "db_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_1_cidr
}

# Fetch "DB Subnet #2" "Private" info
data "aws_subnet" "db_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_2_cidr
}

# ===================== RDS DATA ===================== #

# Fetch PostgreSQL RDS Instance
data "aws_db_instance" "postgresql" {
  db_instance_identifier = "project-db"
}

# Fetch "Security Group" of PostgreSQL Database
data "aws_security_group" "sg_postgresql" {
  name   = "postgresql-db"
  vpc_id = data.aws_vpc.main.id
}

# Fetch "Secret Manager" of "RDS Module"
data "aws_secretsmanager_secret" "postgresql_secret" {
  name = "postgresql-secret-y" #! VARS
}

# Fetch "Secret Manager Version" of "RDS Module"
data "aws_secretsmanager_secret_version" "postgresql_credentials" {
  secret_id = data.aws_secretsmanager_secret.postgresql_secret.id
}

# ==================================================== #