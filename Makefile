# ==================== Terraform ===================== #

# Terraform install:
terraform:
	sudo yum install -y yum-utils
	sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
	sudo yum -y install terraform

# ======================= Root ======================= #

# Copy ".terraformrc" into /root:
rc:
	cp .terraformrc ~/.terraformrc

# ====================== Modules ===================== #

# Clean up temporal and cache files:
cache:
	find / -type d  -name ".terraform" -exec rm -rf {} \;
	[ -d "$HOME/.terraform.d/plugin-cache" ] && rm -rf $HOME/.terraform.d/plugin-cache/*

# Update repository, dependenties and validate:
init:
	git pull
	cd $(VPC_MODULE_PATH) && terraform init -var-file=../../Terraform.tfvars
	cd $(VPC_MODULE_PATH) && terraform validate
	cd $(RDS_MODULE_PATH) && terraform init -var-file=../../Terraform.tfvars
	cd $(RDS_MODULE_PATH) && terraform validate
	cd $(ECS_MODULE_PATH) && terraform init -var-file=../../Terraform.tfvars
	cd $(ECS_MODULE_PATH) && terraform validate

# Target for planning changes:
plan:
	terraform plan -var-file=Terraform.tfvars

# Target for applying:
apply:
	terraform apply --auto-approve -var-file=Terraform.tfvars

# Target for destroying:
destroy:
	terraform destroy --auto-approve -var-file=Terraform.tfvars

# ====================== Modules ===================== #

# Variables with the path to Modules:
VPC_MODULE_PATH := Modules/VPC
RDS_MODULE_PATH := Modules/RDS
ECS_MODULE_PATH := Modules/ECS

# ======================== VPC ======================= #

# Clean up temporal and cache files in VPC Module:
cache-vpc:
	cd $(VPC_MODULE_PATH) && find / -type d  -name ".terraform" -exec rm -rf {} \;

# Update repository, dependenties and validate in VPC Module:
init-vpc:
	git pull
	cd $(VPC_MODULE_PATH) && terraform init -var-file=../../Terraform.tfvars
	cd $(VPC_MODULE_PATH) && terraform validate

# Target for planning changes only in VPC Module:
plan-vpc:
	cd $(VPC_MODULE_PATH) && terraform plan -var-file=../../Terraform.tfvars

# Target for applying only VPC Module:
apply-vpc:
	cd $(VPC_MODULE_PATH) && terraform apply --auto-approve -var-file=../../Terraform.tfvars

# Target for destroying only VPC Module:
destroy-vpc:
	cd $(VPC_MODULE_PATH) && terraform destroy --auto-approve -var-file=../../Terraform.tfvars

# ======================== RDS ======================= #

# Clean up temporal and cache files in VPC Module:
cache-rds:
	cd $(RDS_MODULE_PATH) && find / -type d  -name ".terraform" -exec rm -rf {} \;

# Update repository, dependenties and validate in RDS Module:
init-rds:
	git pull
	cd $(RDS_MODULE_PATH) && terraform init -var-file=../../Terraform.tfvars
	cd $(RDS_MODULE_PATH) && terraform validate

# Target for planning changes only in RDS Module:
plan-rds:
	cd $(RDS_MODULE_PATH) && terraform plan -var-file=../../Terraform.tfvars

# Target for applying only RDS Module:
apply-rds:
	cd $(RDS_MODULE_PATH) && terraform apply --auto-approve -var-file=../../Terraform.tfvars

# Target for destroying only RDS Module:
destroy-rds:
	cd $(RDS_MODULE_PATH) && terraform destroy --auto-approve -var-file=../../Terraform.tfvars

# ======================== ECS ======================= #

# Clean up temporal and cache files in VPC Module:
cache-ecs:
	cd $(ECS_MODULE_PATH) && find / -type d  -name ".terraform" -exec rm -rf {} \;

# Update repository, dependenties and validate in ECS Module:
init-ecs:
	git pull
	cd $(ECS_MODULE_PATH) && terraform init -var-file=../../Terraform.tfvars
	cd $(ECS_MODULE_PATH) && terraform validate

# Target for planning changes only in ECS Module:
plan-ecs:
	cd $(ECS_MODULE_PATH) && terraform plan -var-file=../../Terraform.tfvars

# Target for applying only ECS Module:
apply-ecs:
	cd $(ECS_MODULE_PATH) && terraform apply --auto-approve -var-file=../../Terraform.tfvars

# Target for destroying only ECS Module:
destroy-ecs:
	cd $(ECS_MODULE_PATH) && terraform destroy --auto-approve -var-file=../../Terraform.tfvars

# ==================================================== #