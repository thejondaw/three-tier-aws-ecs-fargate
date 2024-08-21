# =================== INSTRUCTIONS =================== #

# make check-tools (Check for required tools)
# make terraform (Install Terraform)
# make init (Initialize the Project)
# make fmt (Check Terraform formatting)
# make cache (Clean Cache)

# make plan-all (Plan All Modules)
# - make plan-vpc (Plan VPC Module)
# - make plan-ecr (Plan ECR Module)
# - make plan-rds (Plan RDS Module)
# - make plan-ecs (Plan ECS Module)

# make apply-all (Apply All Modules)
# - make apply-vpc (Apply VPC Module)
# - make apply-ecr (Apply ECR Module)
# - make apply-rds (Apply RDS Module)
# - make apply-ecs (Apply ECS Module)

# make destroy-all (Destroy All Resources)
# - make destroy-ecs (Destroy ECS Module)
# - make destroy-rds (Destroy RDS Module)
# - make destroy-ecr (Destroy ECR Module)
# - make destroy-vpc (Destroy VPC Module)

# ==================== VARIABLES ====================== #

TERRAFORM := terraform
ROOT_DIR := $(shell pwd)
TFVARS_FILE := $(ROOT_DIR)/Terraform.tfvars
TERRAFORM_INIT := $(TERRAFORM) init
TERRAFORM_VALIDATE := $(TERRAFORM) validate
TERRAFORM_PLAN := $(TERRAFORM) plan -var-file=$(TFVARS_FILE)
TERRAFORM_APPLY := $(TERRAFORM) apply --auto-approve -var-file=$(TFVARS_FILE)
TERRAFORM_DESTROY := $(TERRAFORM) destroy --auto-approve -var-file=$(TFVARS_FILE)

VPC_MODULE_PATH := Modules/VPC
ECR_MODULE_PATH := Modules/ECR
RDS_MODULE_PATH := Modules/RDS
ECS_MODULE_PATH := Modules/ECS

# ===================== TARGETS ======================= #

.PHONY: terraform cache init plan plan-vpc plan-ecr plan-rds plan-ecs plan-all apply apply-vpc apply-ecr apply-rds apply-ecs apply-all destroy destroy-vpc destroy-ecr destroy-rds destroy-ecs destroy-all

# ============== CHECK REQUIRED TOOLS ================= #

check-tools:
	@which git >/dev/null || (echo "Error: git is not installed"; exit 1)
	@which terraform >/dev/null || (echo "Error: terraform is not installed. Run 'make terraform' to install."; exit 1)

# ================= TERRAFORM SETUP =================== #

terraform:
	sudo yum install -y yum-utils && \
	sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
	sudo yum -y install terraform && \
	cp .terraformrc ~/.terraformrc

init:
	git pull && \
	for module in $(VPC_MODULE_PATH) $(ECR_MODULE_PATH) $(RDS_MODULE_PATH) $(ECS_MODULE_PATH); do \
		cd $$module && $(TERRAFORM_INIT) && $(TERRAFORM_VALIDATE) && cd $(ROOT_DIR); \
	done

fmt:
	@echo "Checking Terraform formatting..."
	@for module in $(VPC_MODULE_PATH) $(ECR_MODULE_PATH) $(RDS_MODULE_PATH) $(ECS_MODULE_PATH); do \
		cd $$module && $(TERRAFORM) fmt -check && cd $(ROOT_DIR) || exit 1; \
	done
	@echo "Terraform formatting check passed."

cache:
	find / -type d -name ".terraform" -exec rm -rf {} + && \
	rm -rf $$HOME/.terraform.d/plugin-cache/*

# ================= PLAN OPERATIONS =================== #

plan:
	@echo "Specify a module: make plan-vpc, make plan-ecr, make plan-rds, or make plan-ecs"
	@echo "Or use 'make plan-all' to plan all resources"

plan-vpc:
	cd $(VPC_MODULE_PATH) && $(TERRAFORM_PLAN)

plan-ecr:
	cd $(ECR_MODULE_PATH) && $(TERRAFORM_PLAN)

plan-rds:
	cd $(RDS_MODULE_PATH) && $(TERRAFORM_PLAN)

plan-ecs:
	cd $(ECS_MODULE_PATH) && $(TERRAFORM_PLAN)

plan-all:
	@echo "Planning all resources..."
	@make plan-vpc
	@make plan-ecr
	@make plan-rds
	@make plan-ecs
	@echo "All resources have been planned."

# ================ APPLY OPERATIONS =================== #

apply:
	@echo "Specify a module: make apply-vpc, make apply-ecr, make apply-rds, or make apply-ecs"
	@echo "Or use 'make apply-all' to apply all resources"

apply-vpc:
	cd $(VPC_MODULE_PATH) && $(TERRAFORM_APPLY)

apply-ecr:
	cd $(ECR_MODULE_PATH) && $(TERRAFORM_APPLY)

apply-rds:
	cd $(RDS_MODULE_PATH) && $(TERRAFORM_APPLY)

apply-ecs:
	cd $(ECS_MODULE_PATH) && $(TERRAFORM_APPLY)

apply-all:
	@echo "Applying all resources..."
	@make apply-vpc
	@make apply-ecr
	@make apply-rds
	@make apply-ecs
	@echo "All resources have been applied."

# =============== DESTROY OPERATIONS ================== #

destroy:
	@echo "Specify a module: make destroy-ecs, make destroy-rds, make destroy-ecr, or make destroy-vpc"
	@echo "Or use 'make destroy-all' to destroy all resources"

destroy-vpc:
	cd $(VPC_MODULE_PATH) && $(TERRAFORM_DESTROY)

destroy-ecr:
	cd $(ECR_MODULE_PATH) && $(TERRAFORM_DESTROY)

destroy-rds:
	cd $(RDS_MODULE_PATH) && $(TERRAFORM_DESTROY)

destroy-ecs:
	cd $(ECS_MODULE_PATH) && $(TERRAFORM_DESTROY)

destroy-all:
	@echo "Destroying all resources..."
	@make destroy-ecs
	@make destroy-rds
	@make destroy-ecr
	@make destroy-vpc
	@echo "All resources have been destroyed."