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

# "DB Subnet #1" "Private"
resource "aws_subnet" "subnet_db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_db_1_cidr
  availability_zone = "us-east-2a"
}

# "DB Subnet #2" "Private"
resource "aws_subnet" "subnet_db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_db_2_cidr
  availability_zone = "us-east-2b"
}

# ============ NAT GATEWAY & ROUTE TABLE ============= #

# "Elastic IP #1" for "NAT Gateway #1"
resource "aws_eip" "project_eip_1" {
  domain = "vpc"
}

# "Elastic IP #2" for "NAT Gateway #2"
resource "aws_eip" "project_eip_2" {
  domain = "vpc"
}

# "NAT Gateway #1"
resource "aws_nat_gateway" "ngw_1" {
  allocation_id = aws_eip.project_eip_1.id
  subnet_id     = aws_subnet.subnet_web_1.id
}

# "NAT Gateway #2"
resource "aws_nat_gateway" "ngw_2" {
  allocation_id = aws_eip.project_eip_2.id
  subnet_id     = aws_subnet.subnet_web_2.id
}

# "Route Table" for "Private Subnets" #1
resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.main.id
}

# "Route Table" for "Private Subnets" #2
resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.main.id
}


# "Route" for "NAT Gateway #1" to "Private Subnets" #1
resource "aws_route" "private_route_1" {
  route_table_id         = aws_route_table.private_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_1.id
}

# "Route" for "NAT Gateway #2" to "Private Subnets" #2
resource "aws_route" "private_route_2" {
  route_table_id         = aws_route_table.private_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_2.id
}

# ==================================================== #

# Association of "DB Subnet #1" "Private", with "Route Table #1"
resource "aws_route_table_association" "private_db_1" {
  subnet_id      = aws_subnet.subnet_db_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

# Association of "DB Subnet #2" "Private", with "Route Table #2"
resource "aws_route_table_association" "private_db_2" {
  subnet_id      = aws_subnet.subnet_db_2.id
  route_table_id = aws_route_table.private_rt_2.id
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

  # "API"
  ingress {
    description = "Allow incoming traffic for API"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
