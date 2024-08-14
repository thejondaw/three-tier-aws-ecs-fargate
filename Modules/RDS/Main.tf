# ==================== RDS Module ==================== #

# "RDS Cluster" "Aurora PostgreSQL - Serverless v2"
resource "aws_rds_cluster" "aurora_postgresql_rds" {
  cluster_identifier     = "aurora-postgresql-rds"
  engine                 = "aurora-postgresql"
  engine_mode            = "provisioned"
  engine_version         = "15.3"
  database_name          = var.db_name
  master_username        = var.db_username
  master_password        = var.db_password
  storage_encrypted      = true
  db_subnet_group_name   = aws_db_subnet_group.subnet_group_rds.name
  vpc_security_group_ids = [aws_security_group.sec_group_rds.id]
  skip_final_snapshot    = true
  enable_http_endpoint   = true
  availability_zones     = [
    "us-east-2a", #! VARS
    "us-east-2b", #! VARS
    "us-east-2c"  #! VARS
    ]

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

# Instance for "Serverless v2" "RDS Cluster"
resource "aws_rds_cluster_instance" "rds_instance" {
  cluster_identifier = aws_rds_cluster.aurora_postgresql_rds.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_postgresql_rds.engine
  engine_version     = aws_rds_cluster.aurora_postgresql_rds.engine_version
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# "Subnet Group" for "Database"
resource "aws_db_subnet_group" "subnet_group_rds" {
  name       = "subnet-group-rds"
  subnet_ids = [
    data.aws_subnet.db_1.id,
    data.aws_subnet.db_2.id,
    data.aws_subnet.db_3.id
    ]
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# "Security Group" to "Aurora PostgreSQL" Database access
resource "aws_security_group" "sec_group_rds" {
  name        = "sec-group-rds"
  description = "Allow Aurora PostgreSQL access"
  vpc_id      = data.aws_vpc.main.id

 # Default "PostgreSQL Port"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all "Outbound Traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ================== SECRET MANAGER ================== #

# "Secret Manager"
resource "aws_secretsmanager_secret" "secret_manager_rds" {
  name = var.secret_manager_name
}

# "Credentials" for "Secret Manager"
resource "aws_secretsmanager_secret_version" "secret_manager_credentials" {
  secret_id = aws_secretsmanager_secret.secret_manager_rds.id
  secret_string = jsonencode({
    username = aws_rds_cluster.aurora_postgresql_rds.master_username
    password = aws_rds_cluster.aurora_postgresql_rds.master_password
    host     = aws_rds_cluster.aurora_postgresql_rds.endpoint
    port     = aws_rds_cluster.aurora_postgresql_rds.port
    dbname   = aws_rds_cluster.aurora_postgresql_rds.database_name
  })
}
