# ==================================================== #

# # "Subnet Group" on "Private Subnets":
# resource "aws_db_subnet_group" "ecs_subnet_group" {
#   name = "ecs-subnet-group"
#   subnet_ids = [
#     var.subnet_api_id,
#     var.subnet_db_id
#   ]
# }

# # ==================================================== #

# # "Security Group" to "PostgreSQL Database" access:
# resource "aws_security_group" "sg_db" {
#   name        = "ecs-db"
#   description = "Allow PostgreSQL Database access"

#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # ==================================================== #

# # "Radom User" for "Secret Manager":
# resource "random_password" "user" {
#   length  = 8
#   special = false
#   numeric = false
#   upper   = false
# }

# # "Random Password" for "Secret Manager":
# resource "random_password" "password" {
#   length  = 16
#   special = true
#   numeric = true
#   upper   = false
# }

# # "Secret Manager":
# resource "aws_secretsmanager_secret" "secret_manager_db" {
#   name = "secret-manager-db"
# }

# # Attach "Credentials" for "Secret Manager":
# resource "aws_secretsmanager_secret_version" "db_credentials" {
#   secret_id = aws_secretsmanager_secret.secret_manager_db.id
#   secret_string = jsonencode({
#     username = random_password.user.result
#     password = random_password.password.result
#     host     = aws_db_instance.default.address
#     db_name  = "toptal_project"
#   })
# }

# ==================================================== #

# # "Database" - "PostgreSQL":
# resource "aws_db_instance" "default" {
#   db_subnet_group_name   = aws_db_subnet_group.ecs_subnet_group.name
#   allocated_storage      = 10
#   db_name                = "toptal"
#   engine                 = "postgres"
#   engine_version         = "13.6"
#   instance_class         = "db.t3.micro"
#   username               = random_password.user.result
#   password               = random_password.password.result
#   parameter_group_name   = "default.postgres13"
#   skip_final_snapshot    = true
#   publicly_accessible    = false
#   vpc_security_group_ids = [aws_security_group.sg_db.id]
# }

# ==================================================== #

# "Subnet Group" for Database:
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = [var.subnet_api_id, var.subnet_db_id]
}

# ==================================================== #

# "Security Group" to "Aurora PostgreSQL" Database access:
resource "aws_security_group" "sg_aurora" {
  name        = "aurora-db"
  description = "Allow Aurora PostgreSQL access"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==================================================== #

# Random "Password" for "Secret Manager":
resource "random_password" "aurora_password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
}

# "Secret Manager":
resource "aws_secretsmanager_secret" "aurora_secret" {
  name = "aurora-secret-manager"
}

# Attach "Credentials" for "Secret Manager":
resource "aws_secretsmanager_secret_version" "aurora_credentials" {
  secret_id = aws_secretsmanager_secret.aurora_secret.id
  secret_string = jsonencode({
    username = "user" # VARS
    password = random_password.aurora_password.result
    host     = aws_rds_cluster.aurora_postgresql.endpoint
    port     = aws_rds_cluster.aurora_postgresql.port
    dbname   = aws_rds_cluster.aurora_postgresql.database_name
  })
}

# ==================================================== #

# "Serverless v2 RDS cluster" - "Aurora PostgreSQL":
resource "aws_rds_cluster" "aurora_postgresql" {
  cluster_identifier     = "example"
  engine                 = "aurora-postgresql"
  engine_mode            = "provisioned"
  engine_version         = "13.6"
  database_name          = "toptal"   # VARS
  master_username        = "username" # VARS
  master_password        = random_password.aurora_password.result
  storage_encrypted      = true
  db_subnet_group_name   = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg_aurora.id]

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

# Instance for "Serverless v2 RDS Cluster":
resource "aws_rds_cluster_instance" "rds_instance" {
  cluster_identifier = aws_rds_cluster.aurora_postgresql.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_postgresql.engine
  engine_version     = aws_rds_cluster.aurora_postgresql.engine_version
}

# ==================================================== #
