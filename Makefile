# ======================= Root ======================= #

# Clean up temporal and cache files:
cache:
	find / -type d  -name ".terraform" -exec rm -rf {} \;

# Update repository, dependenties and validate:
init:
	git pull
	terraform init
	terraform validate

# Target for planning changes:
plan:
	terraform plan

# Target for applying:
apply:
	terraform init
	terraform apply

# Target for destroying:
destroy:
	terraform destroy

# ====================== Modules ===================== #

# Variables with the path to Modules:
VPC_MODULE_PATH := Modules/VPC
RDS_MODULE_PATH := Modules/RDS
ECS_MODULE_PATH := Modules/ECS

# ======================== VPC ======================= #

# Update repository, dependenties and validate in VPC Module:
init-vpc:
	git pull
	terraform init -backend-config="key=Toptal/VPC/terraform.tfstate"
	terraform validate -target=module.VPC

# Target for planning changes only in VPC Module:
plan-vpc:
	terraform plan -target=module.VPC

# Target for applying only VPC Module:
apply-vpc:
	terraform apply -target=module.VPC

# Target for destroying only VPC Module:
destroy-vpc:
	terraform destroy -target=module.VPC

# ======================== RDS ======================= #

# Update repository, dependenties and validate in RDS Module:
init-rds:
	git pull
	terraform init -backend-config="key=Toptal/RDS/terraform.tfstate"
	terraform validate -target=module.RDS

# Target for planning changes only in RDS Module:
plan-rds:
	terraform plan -target=module.RDS

# Target for applying only RDS Module:
apply-rds:
	terraform apply -target=module.RDS

# Target for destroying only RDS Module:
destroy-rds:
	terraform destroy -target=module.RDS

# ======================== ECS ======================= #

# Update repository, dependenties and validate in ECS Module:
init-ecs:
	git pull
	terraform init -backend-config="key=Toptal/ECS/terraform.tfstate"
	terraform validate -target=module.ECS

# Target for planning changes only in ECS Module:
plan-ecs:
	terraform plan -target=module.ECS

# Target for applying only ECS Module:
apply-ecs:
	terraform apply -target=module.ECS

# Target for destroying only ECS Module:
destroy-ecs:
	terraform destroy -target=module.ECS

# ==================================================== #