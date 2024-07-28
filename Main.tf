# ==================== ROOT MAIN ===================== #

# AWS Region
provider "aws" {
  region = var.region_rv
}

# ================== CUSTOM MODULES ================== #

# "VPC" Module
module "vpc" {
  source            = "./Modules/VPC"
  region            = var.region_rv
  vpc_cidr          = var.vpc_cidr_id
  subnet_web_1_cidr = var.subnet_web_1_cidr_id
  subnet_web_2_cidr = var.subnet_web_2_cidr_id
  subnet_api_1_cidr = var.subnet_api_1_cidr_id
  subnet_api_2_cidr = var.subnet_api_2_cidr_id
  subnet_db_1_cidr  = var.subnet_db_1_cidr_id
  subnet_db_2_cidr  = var.subnet_db_2_cidr_id
}

# "RDS" Module
module "rds" {
  source            = "./Modules/RDS"
  region            = var.region_rv
  vpc_cidr          = module.vpc.vpc_id
  subnet_api_1_cidr = module.vpc.subnet_api_1_cidr_id
  subnet_api_2_cidr = module.vpc.subnet_api_2_cidr_id
  subnet_db_1_cidr  = module.vpc.subnet_db_1_cidr_id
  subnet_db_2_cidr  = module.vpc.subnet_db_2_cidr_id
}

# "ECS" Module
module "ecs" {
  source            = "./Modules/ECS"
  region            = var.region_rv
  vpc_cidr          = module.vpc.vpc_id
  subnet_web_1_cidr = module.vpc.subnet_web_1_cidr_id
  subnet_web_2_cidr = module.vpc.subnet_web_2_cidr_id
  subnet_api_1_cidr = module.vpc.subnet_api_1_cidr_id
  subnet_api_2_cidr = module.vpc.subnet_api_2_cidr_id
  subnet_db_1_cidr  = module.vpc.subnet_db_1_cidr_id
  subnet_db_2_cidr  = module.vpc.subnet_db_2_cidr_id
}

# ==================================================== #
