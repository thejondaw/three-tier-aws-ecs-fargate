# ==================== ECR MODULE ==================== #

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
  # Authentication to ECR, "Build & Push" "API" & "WEB" Applications
  provisioner "local-exec" {
    command = <<-EOT
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.api.repository_url}

      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.web.repository_url}

      cd ${path.module}/Applications/API || exit
      docker buildx build --platform linux/amd64 -t ${aws_ecr_repository.api.repository_url}:latest .
      docker push ${aws_ecr_repository.api.repository_url}:latest

      cd ${path.module}/Applications/WEB || exit
      docker buildx build --platform linux/amd64 -t ${aws_ecr_repository.web.repository_url}:latest .
      docker push ${aws_ecr_repository.web.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.api, aws_ecr_repository.web]
}
