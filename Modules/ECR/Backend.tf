# =========== S3 BUCKET FOR BACKEND OF IAM =========== #

# "S3 Bucket" - Backend
terraform {
  backend "s3" {
    region = "us-east-2"                     #! VARS
    bucket = "mrjondaw"                      #! VARS
    key    = "toptal/ECR/terraform.tfstate"  #! VARS
  }
}
