# --- --- --- --- --- --- --- --- --- --- #

# Configure AWS Provider
provider "aws" {
  region = var.region
}

# --- --- --- --- --- --- --- --- --- --- #

# Backend for RDS
terraform {
  backend "s3" {
    bucket = var.bucket
    key    = "Toptal/RDS"
    region = var.region
  }
}

# --- --- --- --- --- --- --- --- --- --- #