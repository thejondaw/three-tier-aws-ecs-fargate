output "secret_manager_db_arn" {
  value       = aws_secretsmanager_secret.secret_manager_db.arn
  description = "ARN of the Secret Manager DB secret"
}