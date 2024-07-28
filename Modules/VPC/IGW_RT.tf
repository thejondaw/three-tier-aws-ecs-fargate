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
  subnet_id      = aws_subnet.subnet_web_1.id
  route_table_id = aws_route_table.public_rt.id
}

# ==================================================== #