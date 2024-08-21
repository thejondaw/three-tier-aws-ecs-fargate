# =================== CREDENTIALS ==================== #

# Set "AWS Region"
region = "us-east-2" # Ohio

# Set "IP Range" of "VPC"
vpc_cidr = "10.0.0.0/16"

# Set "CIDR Blocks" for "Public Subnets"
subnet_web_1_cidr = "10.0.1.0/24"
subnet_web_2_cidr = "10.0.2.0/24"
subnet_web_3_cidr = "10.0.3.0/24"

# Set "CIDR Blocks" for "Private Subnets"
subnet_db_1_cidr = "10.0.11.0/24"
subnet_db_2_cidr = "10.0.12.0/24"
subnet_db_3_cidr = "10.0.13.0/24"

# Set details of "Database"
db_name             = "gigabase"
db_username         = "jondaw"
db_password         = "super-strong-password"
secret_manager_name = "secret-manager-srg"

# Set "ECR Credentials"
ecr_repository_name_api = "app-api"
ecr_repository_name_web = "app-web"
docker_image_tag        = "latest"
aws_cli_profile         = "default"
