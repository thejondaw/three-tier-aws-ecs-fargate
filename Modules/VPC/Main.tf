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

# ============ NAT GATEWAY & ROUTE TABLE ============= #

# "Elastic IP" for "NAT Gateway"
resource "aws_eip" "project_eip" {
  domain = "vpc"
}

# "NAT Gateway"
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.project_eip.id
  subnet_id     = aws_subnet.subnet_web_1.id
}

# "Route Table" for "Private Subnets"
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

# "Route" for "NAT Gateway" to "Private Subnets"
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

# ==================================================== #

# Association of "API Subnet #1" "Private", with "Route Table"
resource "aws_route_table_association" "private_api_1" {
  subnet_id      = aws_subnet.subnet_api_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Association of "API Subnet #2" "Private", with "Route Table"
resource "aws_route_table_association" "private_api_2" {
  subnet_id      = aws_subnet.subnet_api_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Association of "DB Subnet #2" "Private", with "Route Table"
resource "aws_route_table_association" "private_db_1" {
  subnet_id      = aws_subnet.subnet_db_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Association of "DB Subnet #2" "Private", with "Route Table"
resource "aws_route_table_association" "private_db_2" {
  subnet_id      = aws_subnet.subnet_db_2.id
  route_table_id = aws_route_table.private_rt.id
}

# ========== INTERNET GATEWAY & ROUTE TABLE ========== #

# "Internet Gateway" (IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# "Route Table" Attach "IGW" to "Public Subnets"
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Association of "WEB Subnet #1" "Public", with "Route Table"
resource "aws_route_table_association" "public_web_1" {
  subnet_id      = aws_subnet.subnet_web_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Association of "WEB Subnet #2" "Public", with "Route Table"
resource "aws_route_table_association" "public_web_2" {
  subnet_id      = aws_subnet.subnet_web_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ============== SECURITY GROUP OF VPC =============== #

# "Security Group" - Allow connect to "HTTP" and "SSH"
resource "aws_security_group" "sec_group_vpc" {
  name        = "sec-group-vpc"
  description = "Allow incoming HTTP Connections"
  vpc_id      = aws_vpc.main.id

  # "HTTP"
  ingress {
    description = "Allow incoming HTTP for redirect to HTTPS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # "HTTPS"
  ingress {
    description = "Allow incoming HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # "SSH"
  ingress {
    description = "Allow SSH from only our VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all "Outbound Traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==================================================== #