# ==================== VPC Output ==================== # 

# Output of "VPC":
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output of "Public Subnet #1 (WEB)":
output "subnet_web_id" {
  value = aws_subnet.subnet_web.id
}

# Output of "Public Subnet #2 (ALB)":
output "subnet_alb_id" {
  value = aws_subnet.subnet_alb.id
}

# Output of "Private Subnet #3 (API)":
output "subnet_api_id" {
  value = aws_subnet.subnet_api.id
}

# Output of "Private Subnet #4 (DB)":
output "subnet_db_id" {
  value = aws_subnet.subnet_db.id
}

# ==================================================== #