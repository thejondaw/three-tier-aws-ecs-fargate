# ==================================================== #

# Output of Database Secret Manager:
output "secret_manager_db_arn" {
  value       = aws_secretsmanager_secret.secret_manager_db.arn
  description = "ARN of Secret Manager DB secret"
}

# ==================================================== #