# --- --- --- --- --- --- --- --- --- --- #

# Output for DB Instance Endpoint
output "db_instance_endpoint" {
  description = "The connection endpoint for the PostgreSQL DB instance."
  value       = aws_db_instance.default.endpoint
}

# Output for DB Instance Address
output "db_instance_address" {
  description = "The address of the PostgreSQL DB instance."
  value       = aws_db_instance.default.address
}

# Output for DB Instance Identifier
output "db_instance_identifier" {
  description = "The RDS instance identifier."
  value       = aws_db_instance.default.id
}

# Output for DB Subnet Group
output "db_subnet_group" {
  description = "The DB subnet group name."
  value       = aws_db_subnet_group.ecs_subnet_group.name
}

# Output for Security Group ID
output "db_security_group_id" {
  description = "The ID of the security group for the RDS instance."
  value       = aws_security_group.ecs_db.id
}

# Output for Secrets Manager Secret ARN
output "secretsmanager_secret_arn" {
  description = "The ARN of the Secrets Manager secret storing the DB credentials."
  value       = aws_secretsmanager_secret.ecs_db_credentials.arn
}

# Output for Secrets Manager Secret Version ID
output "secretsmanager_secret_version_id" {
  description = "The version ID of the Secrets Manager secret."
  value       = aws_secretsmanager_secret_version.db_credentials.version_id
}

# Output for DB Username (From Secrets Manager)
output "db_username" {
  description = "The database username stored in Secrets Manager."
  value       = jsondecode(aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
}

# Output for DB Password (From Secrets Manager)
output "db_password" {
  description = "The database password stored in Secrets Manager."
  value       = jsondecode(aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
}

# Output for DB Name
output "db_name" {
  description = "The name of the database."
  value       = aws_db_instance.default.db_name
}

# --- --- --- --- --- --- --- --- --- --- #