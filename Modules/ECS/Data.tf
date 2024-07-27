# ==================================================== #
# ======================= DATA ======================= #
# ==================================================== #

# Fetch "VPC" info:
data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Fetch "Private Subnet #1 (WEB)" info:
data "aws_subnet" "web" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_web_cidr
}

# Fetch "Private Subnet #2 (ALB)" info:
data "aws_subnet" "alb" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_alb_cidr
}

# Fetch "Private Subnet #3 (API)" info:
data "aws_subnet" "api" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_api_cidr
}

data "aws_subnet" "db" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_cidr
}

# ==================================================== #

# "Security Group" to "Aurora PostgreSQL" Database access:
data "aws_security_group" "sg_aurora" {
  name        = "aurora-db"
  vpc_id      = data.aws_vpc.main.id
}

# ==================================================== #

# "Secret Manager":
data "aws_secretsmanager_secret" "aurora_secret" {
  name = "aurora-secret-project"
}

# ==================================================== #