# --- --- --- --- --- --- --- --- --- --- #

# VPC Module
module "vpc" {
  source = "./Modules/VPC"

  subnet_1_cidr = var.subnet_1_cidr
  subnet_2_cidr = var.subnet_2_cidr
  subnet_3_cidr = var.subnet_3_cidr
}

# RDS Module
module "rds" {
  source = "./Modules/RDS"

  subnet_ids = [
    module.vpc.subnet_1_id,
    module.vpc.subnet_2_id
  ]
}

# --- --- --- --- --- --- --- --- --- --- #