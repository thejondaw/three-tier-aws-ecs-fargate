# ==================================================== #
# =============== Output of RDS Module =============== # 
# ==================================================== #

# Output of Database "Secret Manager":
output "aurora_secret_arn" {
  value       = aws_secretsmanager_secret.aurora_secret.arn
  description = "ARN of Secret Manager DB secret"
}

# ==================================================== #