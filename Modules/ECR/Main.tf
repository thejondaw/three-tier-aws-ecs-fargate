# ==================== ECR MODULE ==================== #

# "IAM User" for "ECR" access
resource "aws_iam_user" "ecr_user" {
  name = "ecr-access-user"
}

# Access key for "IAM User"
resource "aws_iam_access_key" "ecr_user_key" {
  user = aws_iam_user.ecr_user.name
}

# Attach policies to "IAM User"
resource "aws_iam_user_policy_attachment" "ecr_full_access" {
  user       = aws_iam_user.ecr_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# Store credentials in "Secrets Manager"
resource "aws_secretsmanager_secret" "ecr_user_credentials" {
  name = "ecr-user-credentials"
}

resource "aws_secretsmanager_secret_version" "ecr_user_credentials" {
  secret_id = aws_secretsmanager_secret.ecr_user_credentials.id
  secret_string = jsonencode({
    access_key = aws_iam_access_key.ecr_user_key.id
    secret_key = aws_iam_access_key.ecr_user_key.secret
  })
}

# ================== ECR CONTAINERS ================== #

# Create "ECR Repository" for "API Application"
resource "aws_ecr_repository" "api" {
  name = var.ecr_repository_name_api
}

# Create "ECR Repository" for "Web Application"
resource "aws_ecr_repository" "web" {
  name = var.ecr_repository_name_web
}

# Automate Docker "build" and "push" process
resource "null_resource" "docker_build_push" {
  triggers = {
    api_repo_url = aws_ecr_repository.api.repository_url
    web_repo_url = aws_ecr_repository.web.repository_url
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Get "URI" of Repositories
      API_REPO=${aws_ecr_repository.api.repository_url}
      WEB_REPO=${aws_ecr_repository.web.repository_url}

      # Authenticate in "ECR"
      aws ecr get-login-password --region ${var.region} --profile ${var.aws_cli_profile} | sudo docker login --username AWS --password-stdin ${aws_ecr_repository.api.repository_url}

      # Build and deployment process for "API Application"
      cd ${path.module}/../../API
      sudo docker buildx build --platform linux/amd64 -t $API_REPO:${var.docker_image_tag} .
      sudo docker push $API_REPO:${var.docker_image_tag}

      # Build and deployment process for "WEB Application"
      cd ${path.module}/../../WEB
      sudo docker buildx build --platform linux/amd64 -t $WEB_REPO:${var.docker_image_tag} .
      sudo docker push $WEB_REPO:${var.docker_image_tag}
    EOT
  }

  depends_on = [aws_ecr_repository.api, aws_ecr_repository.web]
}
