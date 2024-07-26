# ==================================================== #
# ==================== ROOT Main ===================== #
# ==================================================== #

# "AWS Provider" - Region:
provider "aws" {
  region = var.region_rv
}

# ================== Custom Modules ================== #

# "VPC" Module:
module "vpc" {
  source          = "./Modules/VPC"
  region          = var.region_rv
  vpc_cidr        = var.vpc_cidr_rv
  subnet_web_cidr = var.subnet_web_cidr_rv
  subnet_alb_cidr = var.subnet_alb_cidr_rv
  subnet_api_cidr = var.subnet_api_cidr_rv
  subnet_db_cidr  = var.subnet_db_cidr_rv
}

# "RDS" Module:
module "rds" {
  source          = "./Modules/RDS"
  region          = var.region_rv
  vpc_cidr        = module.vpc.vpc_arn
  subnet_api_cidr = var.subnet_api_cidr_rv
  subnet_db_cidr  = var.subnet_db_cidr_rv
}

# "ECS" Module:
module "ecs" {
  source            = "./Modules/ECS"
  region            = var.region_rv
  # aurora_secret     = module.rds.aurora_secret_arn
  vpc_cidr          = module.vpc.vpc_arn
  subnet_web_cidr   = module.vpc.subnet_web_arn
  subnet_alb_cidr   = module.vpc.subnet_alb_arn
  subnet_api_cidr   = module.vpc.subnet_api_arn
}

# ==================================================== #
