# =========== S3 BUCKET FOR BACKEND OF RDS =========== #

# "S3 Bucket" - Backend
terraform {
  backend "s3" {
    region = "us-east-2"                     #! VARS
    bucket = "mrjondaw"                      #! VARS
    key    = "toptal/RDS/terraform.tfstate"  #! VARS
  }
}
