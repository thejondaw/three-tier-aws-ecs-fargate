# ============== OUTPUTS OF VPC MODULE =============== #

# "CIDR" "Output" of "VPC"
output "vpc_id" {
  value = aws_vpc.main.id
}

# "CIDR" "Output" of "WEB Subnet #1" "Public"
output "subnet_web_1_id" {
  value = aws_subnet.subnet_web_1.id
}

# "CIDR" "Output" of "WEB Subnet #2" "Public"
output "subnet_web_2_id" {
  value = aws_subnet.subnet_web_2.id
}

# "CIDR" "Output" of "DB Subnet #1" "Private"
output "subnet_db_1_id" {
  value = aws_subnet.subnet_db_1.id
}

# "CIDR" "Output" of "DB Subnet #2" "Private"
output "subnet_db_2_id" {
  value = aws_subnet.subnet_db_2.id
}
