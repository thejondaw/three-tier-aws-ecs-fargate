# =========== NAT Gateway and Route Table ============ #

# Elastic IP for NAT Gateway
resource "aws_eip" "project_eip" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.project_eip.id
  subnet_id     = aws_subnet.subnet_web_1.id
}

# Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

# Route for NAT Gateway to Private Subnets
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

# ==================================================== #

# Association of API Subnet #1 - Private, with Route Table
resource "aws_route_table_association" "Private_1" {
  subnet_id      = aws_subnet.subnet_api_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Association of API Subnet #2 - Private, with Route Table
resource "aws_route_table_association" "Private_2" {
  subnet_id      = aws_subnet.subnet_api_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Association of DB Subnet #2 - Private, with Route Table
resource "aws_route_table_association" "Private_2" {
  subnet_id      = aws_subnet.subnet_db_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Association of DB Subnet #2 - Private, with Route Table
resource "aws_route_table_association" "Private_2" {
  subnet_id      = aws_subnet.subnet_db_2.id
  route_table_id = aws_route_table.private_rt.id
}

# ==================================================== #
