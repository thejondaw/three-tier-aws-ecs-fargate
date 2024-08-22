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
