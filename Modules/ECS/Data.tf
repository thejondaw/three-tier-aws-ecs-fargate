# ===================== VPC DATA ===================== #

# Fetch "VPC" info
data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Fetch "WEB Subnet #1" "Public" info:
data "aws_subnet" "web_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_web_1_cidr
}

# Fetch "WEB Subnet #2" "Public" info
data "aws_subnet" "web_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_web_2_cidr
}

# Fetch "DB Subnet #1" "Private" info
data "aws_subnet" "db_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_1_cidr
}

# Fetch "DB Subnet #2" "Private" info
data "aws_subnet" "db_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_2_cidr
}

# ===================== RDS DATA ===================== #

# Fetch RDS Cluster of "Aurora PostgreSQL" Database
data "aws_rds_cluster" "aurora_postgresql" {
  cluster_identifier = "project-db"
}

# Fetch "Security Group" of "Aurora PostgreSQL" Database
data "aws_security_group" "sg_aurora" {
  name   = "aurora-db"
  vpc_id = data.aws_vpc.main.id
}

# Fetch "Secret Manager" of "RDS Module"
data "aws_secretsmanager_secret" "aurora_secret" {
  name = var.aurora_secret_name
}

# Fetch "Secret Manager Version" of "RDS Module"
data "aws_secretsmanager_secret_version" "aurora_credentials" {
  secret_id = data.aws_secretsmanager_secret.aurora_secret.id
}
