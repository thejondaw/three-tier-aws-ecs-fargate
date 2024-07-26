# ==================================================== #
# =============== Output of RDS Module =============== # 
# ==================================================== #

# Output of Database "Secret Manager":
output "secret_manager_db_arn" {
  value       = aws_secretsmanager_secret.aurora_secret.id
  description = "ARN of Secret Manager DB secret"
}

# ==================================================== #
