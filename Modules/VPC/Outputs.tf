# ============== OUTPUTS OF VPC MODULE =============== #

# Output of "VPC"
output "vpc_id" {
  value = aws_vpc.main.id
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# Output of "Public Subnet #1"
output "subnet_web_1_id" {
  value = aws_subnet.subnet_web_1.id
}

# Output of "Public Subnet #2"
output "subnet_web_2_id" {
  value = aws_subnet.subnet_web_2.id
}

# Output of "Public Subnet #3"
output "subnet_web_3_id" {
  value = aws_subnet.subnet_web_3.id
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# Output of "Private Subnet #1"
output "subnet_db_1_id" {
  value = aws_subnet.subnet_db_1.id
}

# Output of "Private Subnet #2"
output "subnet_db_2_id" {
  value = aws_subnet.subnet_db_2.id
}

# Output of "Private Subnet #3"
output "subnet_db_3_id" {
  value = aws_subnet.subnet_db_3.id
}
