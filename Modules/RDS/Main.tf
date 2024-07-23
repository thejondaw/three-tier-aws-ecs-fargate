# ==================================================== #

# Subnet Group on Private Subnets
resource "aws_db_subnet_group" "ecs_subnet_group" {
  name = "ecs-subnet-group"
  subnet_ids = [
    aws_subnet.subnet_3_cidr.id,
    aws_subnet.subnet_4_cidr.id
  ]
}

# ==================================================== #

# Security Group to PostgreSQL access
resource "aws_security_group" "ecs_db" {
  name        = "ecs-db"
  description = "Allow PostgreSQL access"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==================================================== #

# Radom User for Secret Manager
resource "random_password" "user" {
  length  = 8
  special = false
  numeric = false
  upper   = false
}

# Random Password for Secret Manager
resource "random_password" "password" {
  length  = 16
  special = true
  numeric = true
  upper   = false
}

# Secret Manager
resource "aws_secretsmanager_secret" "secret_manager_db" {
  name = "secret-manager-db"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.secret_manager_db.id
  secret_string = jsonencode({
    username = random_password.user.result
    password = random_password.password.result
    host     = aws_db_instance.default.address
    db_name  = "toptal_project"
  })
}

# ==================================================== #

# Database - PostgreSQL
resource "aws_db_instance" "default" {
  db_subnet_group_name   = aws_db_subnet_group.ecs_subnet_group.name
  allocated_storage      = 10
  db_name                = "toptal_project"
  engine                 = "postgres"
  engine_version         = "13.6"
  instance_class         = "db.t3.micro"
  username               = random_password.user.result
  password               = random_password.password.result
  parameter_group_name   = "default.postgres13"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.ecs_db.id]
}

# ==================================================== #