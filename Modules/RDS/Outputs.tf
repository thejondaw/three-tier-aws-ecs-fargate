# ==================================================== #

# Output of Database "Secret Manager":
output "secret_manager_db_arn" {
  value       = aws_secretsmanager_secret.aurora_secret.arn
  description = "ARN of Secret Manager DB secret"
}

# ==================================================== #