# ===================== VPC DATA ===================== #

# Fetch "VPC" info
data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# Fetch "Public Subnet #1" info
data "aws_subnet" "web_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_web_1_cidr
}

# Fetch "Public Subnet #2" info
data "aws_subnet" "web_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_web_2_cidr
}

# Fetch "Public Subnet #3" info
data "aws_subnet" "web_3" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_web_3_cidr
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# Fetch "Private Subnet #1" info
data "aws_subnet" "db_1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_1_cidr
}

# Fetch "Private Subnet #2" info
data "aws_subnet" "db_2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_2_cidr
}

# Fetch "Private Subnet #3" info
data "aws_subnet" "db_3" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.subnet_db_3_cidr
}

# ===================== RDS DATA ===================== #

# Fetch RDS Cluster of "Aurora PostgreSQL - Serverless v2"
data "aws_rds_cluster" "aurora_postgresql_rds" {
  cluster_identifier = "aurora-postgresql-rds"
}

# Fetch "Security Group" of "Aurora PostgreSQL - Serverless v2"
data "aws_security_group" "sec_group_rds" {
  name   = "sec-group-rds"
  vpc_id = data.aws_vpc.main.id
}

# Fetch "Secret Manager" of "RDS Module"
data "aws_secretsmanager_secret" "secret_manager_rds" {
  name = var.secret_manager_name
}

# Fetch "Secret Manager Version" of "RDS Module"
data "aws_secretsmanager_secret_version" "secret_manager_credentials" {
  secret_id = data.aws_secretsmanager_secret.secret_manager_rds.id
}
