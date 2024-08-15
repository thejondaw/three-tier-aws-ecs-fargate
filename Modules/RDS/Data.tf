# ===================== VPC DATA ===================== #

# Fetch "VPC" info
data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Fetch "Private Subnet #1" info
data "aws_subnet" "db_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_1_cidr
}

# Fetch "Private Subnet #2" info
data "aws_subnet" "db_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_2_cidr
}

# Fetch "Private Subnet #3" info
data "aws_subnet" "db_3" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_3_cidr
}
