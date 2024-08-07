# ==================== RDS Module ==================== #

# Standard "PostgreSQL" "RDS Instance"
resource "aws_db_instance" "postgresql" {
  identifier        = "project-db"
  engine            = "postgres"
  engine_version    = "15.2"
  instance_class    = "db.t3.micro"
  allocated_storage = 20 # Storage size in GB

  db_name  = "toptal"   #! VARS
  username = "jondaw"   #! VARS
  password = "password" #! VARS

  storage_encrypted      = true
  db_subnet_group_name   = aws_db_subnet_group.postgresql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg_postgresql.id]

  skip_final_snapshot = true

  # Additional settings as needed
  # multi_az = true  # Uncomment to enable Multi-AZ
}

# Subnet Group for Database
resource "aws_db_subnet_group" "postgresql_subnet_group" {
  name       = "postgresql-subnet-group"
  subnet_ids = [data.aws_subnet.db_1.id, data.aws_subnet.db_2.id]
}

# ==================================================== #
# Security Group for PostgreSQL Database access
resource "aws_security_group" "sg_postgresql" {
  name        = "postgresql-db"
  description = "Allow PostgreSQL access"
  vpc_id      = data.aws_vpc.main.id

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

# ================== SECRET MANAGER ================== #
# Secret Manager
resource "aws_secretsmanager_secret" "postgresql_secret" {
  name = "postgresql-secret-y" #! VARS
}

# Attach Credentials for Secret Manager
resource "aws_secretsmanager_secret_version" "postgresql_credentials" {
  secret_id = aws_secretsmanager_secret.postgresql_secret.id
  secret_string = jsonencode({
    username = aws_db_instance.postgresql.username
    password = aws_db_instance.postgresql.password
    host     = aws_db_instance.postgresql.endpoint
    port     = aws_db_instance.postgresql.port
    dbname   = aws_db_instance.postgresql.db_name
  })
}
# ==================================================== #
