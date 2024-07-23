# ==================================================== #

# AWS Provider - Region:
provider "aws" {
  region = var.region
}

# S3 Bucket - Backend for VPC:
terraform {
  backend "s3" {
    bucket = var.bucket
    key    = "Toptal/ECS/terraform.tfstate"
    region = var.region
  }
}
# ==================================================== #