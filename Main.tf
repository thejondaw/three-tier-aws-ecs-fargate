# ==================================================== #

# "AWS Provider" - Region:
provider "aws" {
  region = var.region
}

# "S3 Bucket" - Backend:
terraform {
  backend "s3" {
    bucket = var.bucket
    key    = "toptal-assesement/terraform.tfstate"
    region = var.region
  }
}

# ================== Local Modules =================== #

# "VPC" Module:
module "vpc" {
  source          = "./Modules/VPC"
  region          = var.region
  bucket          = var.bucket
  subnet_web_cidr = var.subnet_web_cidr
  subnet_alb_cidr = var.subnet_alb_cidr
  subnet_api_cidr = var.subnet_api_cidr
  subnet_db_cidr  = var.subnet_db_cidr
}

# "RDS" Module:
module "rds" {
  source        = "./Modules/RDS"
  region        = var.region
  bucket        = var.bucket
  subnet_api_id = module.vpc.subnet_api_id
  subnet_db_id  = module.vpc.subnet_db_id
  subnet_ids = [
    module.vpc.subnet_api_id,
    module.vpc.subnet_db_id
  ]
}

# "ECS" Module:
module "ecs" {
  source                = "./Modules/ECS"
  region                = var.region
  bucket                = var.bucket
  secret_manager_db_arn = module.rds.secret_manager_db_arn
  vpc_id                = module.vpc.vpc_id
  subnet_web_id         = module.vpc.subnet_web_id
  subnet_alb_id         = module.vpc.subnet_alb_id
  subnet_api_id         = module.vpc.subnet_api_id
}

# ==================================================== #