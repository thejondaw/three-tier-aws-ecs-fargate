# ==================== VPC MODULE ==================== #

# "Virtual Private Cloud" (VPC)
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
}

# ===================== SUBNETS ====================== #

# "WEB Subnet #1" "Public"
resource "aws_subnet" "subnet_web_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_web_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}

# "WEB Subnet #2" "Public"
resource "aws_subnet" "subnet_web_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_web_2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
}

# "API Subnet #1" "Private"
resource "aws_subnet" "subnet_api_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_api_1_cidr
  availability_zone = "us-east-2a"
}

# "API Subnet #2" "Private"
resource "aws_subnet" "subnet_api_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_api_2_cidr
  availability_zone = "us-east-2b"
}

# "DB Subnet #1" "Private"
resource "aws_subnet" "subnet_db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_db_1_cidr
  availability_zone = "us-east-2b"
}

# "DB Subnet #2" "Private"
resource "aws_subnet" "subnet_db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_db_2_cidr
  availability_zone = "us-east-2c"
}

# ==================================================== #