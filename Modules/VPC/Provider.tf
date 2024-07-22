# --- --- --- --- --- --- --- --- --- --- #

# Configure AWS Provider
provider "aws" {
  region = var.region
}

# --- --- --- --- --- --- --- --- --- --- #

# Backend for VPC
terraform {
  backend "s3" {
    bucket = var.bucket
    key    = "Toptal/VPC"
    region = var.region
  }
}

# --- --- --- --- --- --- --- --- --- --- #