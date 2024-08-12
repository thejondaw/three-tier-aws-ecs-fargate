# =================== CREDENTIALS ==================== #

# "AWS Region"
region = "us-east-2"

# IP Range of "VPC"
vpc_cidr = "10.0.0.0/16"

# "Public Subnets"  "WEB"
subnet_web_1_cidr = "10.0.1.0/24"
subnet_web_2_cidr = "10.0.2.0/24"

# "Private Subnets" "DB"
subnet_db_1_cidr = "10.0.11.0/24"
subnet_db_2_cidr = "10.0.12.0/24"

# RDS variables
db_name            = "toptal"
db_username        = "jondaw"
db_password        = "password"
aurora_secret_name = "aurora-secret-qrt"
