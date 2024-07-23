# ==================================================== #

# "Virtual Private Cloud" (VPC):
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
}

# ==================================================== #
# ===================== Subnets ====================== #
# ==================================================== #

# "Public Subnet #1" - WEB:
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}

# "Public Subnet #2" - Application Load Balancer (ALB):
resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
}

# "Private Subnet #3" - API:
resource "aws_subnet" "subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_3_cidr
  availability_zone = "us-east-2a"
}

# "Private Subnet #4" - Database (DB):
resource "aws_subnet" "subnet_4" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_4_cidr
  availability_zone = "us-east-2c"
}

# ==================================================== #
# ========= Internet Gateway and Route Table ========= #
# ==================================================== #

# "Internet Gateway" (IGW):
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# "Route Table" - Attach "IGW" to "Public Subnets":
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Association of "Public Subnet #1" with "Route Table":
resource "aws_route_table_association" "public_web" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Association of "Public Subnet #2" with "Route Table":
resource "aws_route_table_association" "public_alb" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ==================================================== #
# =========== NAT Gateway and Route Table ============ #
# ==================================================== #

# "NAT Gateway":
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.project-eip.id
  subnet_id     = aws_subnet.subnet_1.id
}

# "Route Table" for "Private Subnets":
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

# Route for "NAT Gateway" to "Private Subnets":
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NATgw.id
}

# Association of "Private Subnet #3" with "Route Table":
resource "aws_route_table_association" "Private_1" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.private_rt.id
}

# Association of "Private Subnet #4" with "Route Table":
resource "aws_route_table_association" "Private_2" {
  subnet_id      = aws_subnet.subnet_4.id
  route_table_id = aws_route_table.private_rt.id
}

# ==================================================== #

# "Security Group" - Allow connect to "HTTP" and "SSH":
resource "aws_security_group" "sec_group_http_ssh" {
  name        = "sec-group-http-ssh"
  description = "Allow incoming HTTP Connections"
  vpc_id      = aws_vpc.main.id

  # HTTP:
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  # SSH:
  ingress {
    description = "Allow HTTP from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic:
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==================================================== #