# --- --- --- --- --- --- --- --- --- --- #

# Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
}

# --- --- --- --- --- --- --- --- --- --- #

# Subnet #1 - WEB (Public)
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}

# Subnet #2 - API (Private)
resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_2_cidr
  availability_zone = "us-east-2b"
}

# Subnet #3 - DATABASE (Private)
resource "aws_subnet" "subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_3_cidr
  availability_zone = "us-east-2c"
}

# --- --- --- --- --- --- --- --- --- --- #

# Internet Gateway (IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Route Table - Attach IGW to Subnet (Public)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# --- --- --- --- --- --- --- --- --- --- #

# NAT Gateway
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.project-eip.id
  subnet_id     = aws_subnet.subnet_1.id
}

# --- --- --- --- --- --- --- --- --- --- #

# Route Table for Subnets (Private)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

# Route for NAT Gateway to Subnets (Private)
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NATgw.id
}

# Associate Subnets (Private) with Route Table
resource "aws_route_table_association" "Private1" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "Private2" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.private_rt.id
}

# --- --- --- --- --- --- --- --- --- --- #


# Security Group - Allow connect to HTTP
resource "aws_security_group" "sec_group_http" {
  name        = "sec-group-http"
  description = "Allow incoming HTTP Connections"
  vpc_id      = aws_vpc.main.id

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  # SSH
  ingress {
    description = "Allow HTTP from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- --- --- --- --- --- --- --- --- --- #