# ================= VARIABLES OF ECR ================= #

# Variable for "AWS Region"
variable "region" {
  description = "AWS Region"
  type        = string
}

# Variable for "ECR Repository" name for "API Application"
variable "ecr_repository_name_api" {
  description = "Name of the ECR Repository for API"
  type        = string
}

# Variable for "ECR Repository" name for "WEB Application"
variable "ecr_repository_name_web" {
  description = "Name of the ECR Repository for WEB"
  type        = string
}

# Variable for Docker image tag
variable "docker_image_tag" {
  description = "Tag for Docker images"
  type        = string
  default     = "latest"
}

# Variable for "AWS CLI Profile"
variable "aws_cli_profile" {
  description = "AWS CLI Profile to use for authentication"
  type        = string
  default     = "default"
}
