# ==================================================== #
# ==================== ROOT Main ===================== #
# ==================================================== #

# "AWS Provider" - Region:
provider "aws" {
  region = var.region_rv
}

# "S3 Bucket" - Backend:
terraform {
  backend "s3" {
    region = ""
    bucket = "mrjondaw"
    key    = "toptal/terraform.tfstate"

  }
}

# ================== Custom Modules ================== #

# "VPC" Module:
module "vpc" {
  source          = "./Modules/VPC"
  region          = var.region_rv
  bucket          = var.bucket_rv
  vpc_cidr        = var.vpc_cidr_rv
  subnet_web_cidr = var.subnet_web_cidr_rv
  subnet_alb_cidr = var.subnet_alb_cidr_rv
  subnet_api_cidr = var.subnet_api_cidr_rv
  subnet_db_cidr  = var.subnet_db_cidr_rv
  subnet_api_id   = module.vpc.subnet_api_id
  subnet_db_id    = module.vpc.subnet_db_id
}

# "RDS" Module:
module "rds" {
  source        = "./Modules/RDS"
  region        = var.region_rv
  bucket        = var.bucket_rv
  vpc_cidr      = module.vpc.vpc_arn
  subnet_api_id = module.vpc.subnet_api_id
  subnet_db_id  = module.vpc.subnet_db_id
}

# "ECS" Module:
module "ecs" {
  source            = "./Modules/ECS"
  region            = var.region_rv
  bucket            = var.bucket_rv
  secret_manager_db = module.rds.secret_manager_db_arn
  vpc_cidr          = module.vpc.vpc_arn
  subnet_web_cidr   = module.vpc.subnet_web_arn
  subnet_alb_cidr   = module.vpc.subnet_alb_arn
  subnet_api_cidr   = module.vpc.subnet_api_arn
}

# ==================================================== #
