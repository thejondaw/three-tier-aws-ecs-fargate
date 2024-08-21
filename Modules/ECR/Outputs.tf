# ============== OUTPUTS OF IAM MODULE =============== #

# Output "URL" of "API Repository"
output "api_repository_url" {
  value = aws_ecr_repository.api.repository_url
}

# Output "URL" of "WEB Repository"
output "web_repository_url" {
  value = aws_ecr_repository.web.repository_url
}