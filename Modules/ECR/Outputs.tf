# ============== OUTPUTS OF IAM MODULE =============== #

# Output "Name" of "Secret"
output "ecr_credentials_secret_name" {
  value = aws_secretsmanager_secret.ecr_user_credentials.name
}
