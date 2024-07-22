# --- --- --- --- --- --- --- --- --- --- #

# Output VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Output Subnet IDs
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.subnet_1.id
}

output "private_subnet_2_id" {
  description = "The ID of the private subnet 2"
  value       = aws_subnet.subnet_2.id
}

output "private_subnet_3_id" {
  description = "The ID of the private subnet 3"
  value       = aws_subnet.subnet_3.id
}

# Output Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# Output NAT Gateway ID
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.NATgw.id
}

# Output Security Group ID
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sec_group_http.id
}

# Output Elastic IP ID for NAT Gateway
output "nat_eip_id" {
  description = "The Elastic IP allocation ID for the NAT Gateway"
  value       = aws_eip.project-eip.id
}

# --- --- --- --- --- --- --- --- --- --- #
