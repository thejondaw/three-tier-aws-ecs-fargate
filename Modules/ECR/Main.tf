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

  provisioner "local-exec" {
    command = <<-EOT
      # Authenticate in "ECR"
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.api.repository_url}

      # Build and push "API Application"
      cd ${path.module}/Applications/API
      if [ -f Dockerfile ]; then
        docker buildx build --platform linux/amd64 -t ${aws_ecr_repository.api.repository_url}:${var.docker_image_tag} .
        docker push ${aws_ecr_repository.api.repository_url}:${var.docker_image_tag}
      else
        echo "Dockerfile not found in API directory"
      fi

      # Build and push "WEB Application"
      cd ${path.module}/Applications/WEB
      if [ -f Dockerfile ]; then
        docker buildx build --platform linux/amd64 -t ${aws_ecr_repository.web.repository_url}:${var.docker_image_tag} .
        docker push ${aws_ecr_repository.web.repository_url}:${var.docker_image_tag}
      else
        echo "Dockerfile not found in WEB directory"
      fi
    EOT
  }

  depends_on = [aws_ecr_repository.api, aws_ecr_repository.web]
}
