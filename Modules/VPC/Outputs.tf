# ==================================================== #
# ==================== VPC Output ==================== # 
# ==================================================== #

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_web_id" {
  value = aws_subnet.subnet_1.id
}

output "subnet_alb_id" {
  value = aws_subnet.subnet_2.id
}

output "subnet_api_id" {
  value = aws_subnet.subnet_3.id
}

output "subnet_database_id" {
  value = aws_subnet.subnet_4.id
}

# ==================================================== #