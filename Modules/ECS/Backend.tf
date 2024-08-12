# =========== S3 BUCKET FOR BACKEND OF ECS =========== #

# "S3 Bucket" - Backend
terraform {
  backend "s3" {
    region = "us-east-2"
    bucket = "mrjondaw"
    key    = "toptal/ECS/terraform.tfstate"
  }
}
