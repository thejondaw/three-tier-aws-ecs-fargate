# ==================================================== #

# "S3 Bucket" - Backend for "VPC":
terraform {
  backend "s3" {
    bucket = var.bucket
    key    = "Toptal/terraform.tfstate"
    region = var.region
  }
}

# ==================================================== #
# ================== Local Modules =================== #
# ==================================================== #

# "VPC" Module:
module "vpc" {
  source = "./Modules/VPC"

  subnet_1_cidr = var.subnet_1_cidr
  subnet_2_cidr = var.subnet_2_cidr
  subnet_3_cidr = var.subnet_3_cidr
}

# "RDS" Module:
module "rds" {
  source = "./Modules/RDS"
  subnet_ids = [
    module.vpc.subnet_1_id,
    module.vpc.subnet_2_id
  ]
}

# "ECS" Module:
module "ecs" {
  source                = "./Modules/ECS"
  secret_manager_db_arn = module.rds.secret_manager_db_arn
  vpc_id                = module.vpc.vpc_id
  subnet_web_id         = module.vpc.subnet_web_id
  subnet_alb_id         = module.vpc.subnet_alb_id
  subnet_api_id         = module.vpc.subnet_api_id
}

# ==================================================== #