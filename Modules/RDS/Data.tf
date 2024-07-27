# ======================= DATA ======================= #

# Fetch VPC info
data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Fetch API Subnet #1 - Private info:
data "aws_subnet" "api_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_api_1_cidr
}

# Fetch API Subnet #2 - Private info
data "aws_subnet" "api_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_api_2_cidr
}

# Fetch DB Subnet #1 - Private info
data "aws_subnet" "db_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_1_cidr
}

# Fetch DB Subnet #2 - Private info
data "aws_subnet" "db_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_2_cidr
}

# ==================================================== #