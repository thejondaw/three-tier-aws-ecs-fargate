# "S3 Bucket" - Backend:
terraform {
  backend "s3" {
    region = var.region
    bucket = "mrjondaw"
    key    = "toptal/RDS/terraform.tfstate"
  }
}