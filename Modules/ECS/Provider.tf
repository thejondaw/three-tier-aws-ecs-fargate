# ==================================================== #

# Configure AWS Provider
provider "aws" {
  region = var.region
}

# ==================================================== #

# Backend for ECS
terraform {
  backend "s3" {
    bucket = var.bucket
    key    = "Toptal/ECS"
    region = var.region
  }
}

# ==================================================== #