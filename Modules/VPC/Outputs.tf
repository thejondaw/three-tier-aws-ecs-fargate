# ==================================================== #
# =============== Output of VPC Module =============== # 
# ==================================================== #

# Output of "VPC":
output "vpc_arn" {
  value = aws_vpc.main.id
}

# Output of "Public Subnet #1 (WEB)":
output "subnet_web_arn" {
  value = aws_subnet.subnet_web.id
}

# Output of "Public Subnet #2 (ALB)":
output "subnet_alb_arn" {
  value = aws_subnet.subnet_alb.id
}

# Output of "Private Subnet #3 (API)":
output "subnet_api_arn" {
  value = aws_subnet.subnet_api.id
}

# Output of "Private Subnet #4 (DB)":
output "subnet_db_arn" {
  value = aws_subnet.subnet_db.id
}

# ==================================================== #