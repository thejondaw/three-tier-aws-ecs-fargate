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
  vpc_cidr          = var.vpc_cidr
  subnet_web_1_cidr = var.subnet_web_1_cidr
  subnet_web_2_cidr = var.subnet_web_2_cidr
  subnet_web_3_cidr = var.subnet_web_3_cidr
  subnet_db_1_cidr  = var.subnet_db_1_cidr
  subnet_db_2_cidr  = var.subnet_db_2_cidr
  subnet_db_3_cidr  = var.subnet_db_3_cidr
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# "RDS" Module
module "rds" {
  source              = "./Modules/RDS"
  region              = var.region_rv
  vpc_cidr            = module.vpc.vpc_id
  subnet_db_1_cidr    = module.vpc.subnet_db_1_id
  subnet_db_2_cidr    = module.vpc.subnet_db_2_id
  subnet_db_3_cidr    = module.vpc.subnet_db_3_id
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  secret_manager_name = var.secret_manager_name
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# "ECR" Module
module "ecr" {
  source                  = "./Modules/ECR"
  region                  = var.region_rv
  ecr_repository_name_api = var.ecr_repository_name_api
  ecr_repository_name_web = var.ecr_repository_name_web
  docker_image_tag        = var.docker_image_tag
  aws_cli_profile         = var.aws_cli_profile
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# "ECS" Module
module "ecs" {
  source                  = "./Modules/ECS"
  region                  = var.region_rv
  vpc_cidr                = module.vpc.vpc_id
  subnet_web_1_cidr       = module.vpc.subnet_web_1_id
  subnet_web_2_cidr       = module.vpc.subnet_web_2_id
  subnet_web_3_cidr       = module.vpc.subnet_web_3_id
  subnet_db_1_cidr        = module.vpc.subnet_db_1_id
  subnet_db_2_cidr        = module.vpc.subnet_db_2_id
  subnet_db_3_cidr        = module.vpc.subnet_db_3_id
  secret_manager_name     = var.secret_manager_name
  docker_image_tag        = var.docker_image_tag
}
