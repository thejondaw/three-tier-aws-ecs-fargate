# ==================================================== #
# ==================== VPC Output ==================== # 
# ==================================================== #

# Output of "VPC":
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output of "Public Subnet #1" - "WEB":
output "subnet_web_id" {
  value = aws_subnet.subnet_1.id
}

# Output of "Public Subnet #2" - "ALB":
output "subnet_alb_id" {
  value = aws_subnet.subnet_2.id
}

# Output of "Private Subnet #3" - "API":
output "subnet_api_id" {
  value = aws_subnet.subnet_3.id
}

# Output of "Private Subnet #4" - "Database":
output "subnet_database_id" {
  value = aws_subnet.subnet_4.id
}

# ==================================================== #