# ====================== INSTRUCTIONS ====================== #
# To use this Makefile:
# 1. Install Terraform and setup: make terraform
# 2. Initialize the project: make init
# 3. Apply all modules: make all
#    Or individually:
#    - VPC: make apply_vpc
#    - RDS: make apply_rds
#    - ECS: make apply_ecs
# 4. To destroy resources: make destroy
#    Or by module: make destroy_vpc, make destroy_rds, make destroy_ecs
# 5. Clean cache: make cache
# ========================================================== #

# Variables
TERRAFORM := terraform
TERRAFORM_INIT := $(TERRAFORM) init -var-file=../../Terraform.tfvars
TERRAFORM_VALIDATE := $(TERRAFORM) validate
TERRAFORM_PLAN := $(TERRAFORM) plan -var-file=../../Terraform.tfvars
TERRAFORM_APPLY := $(TERRAFORM) apply --auto-approve -var-file=../../Terraform.tfvars
TERRAFORM_DESTROY := $(TERRAFORM) destroy --auto-approve -var-file=../../Terraform.tfvars

VPC_MODULE_PATH := Modules/VPC
RDS_MODULE_PATH := Modules/RDS
ECS_MODULE_PATH := Modules/ECS

# Targets
.PHONY: all terraform cache init plan apply destroy

all: init apply_vpc apply_rds apply_ecs

# Installation and setup
terraform:
	sudo yum install -y yum-utils && \
	sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
	sudo yum -y install terraform && \
	cp .terraformrc ~/.terraformrc

# Cleaning and initialization
cache:
	find / -type d -name ".terraform" -exec rm -rf {} + && \
	rm -rf $$HOME/.terraform.d/plugin-cache/*

init:
	git pull && \
	for module in $(VPC_MODULE_PATH) $(RDS_MODULE_PATH) $(ECS_MODULE_PATH); do \
		cd $$module && $(TERRAFORM_INIT) && $(TERRAFORM_VALIDATE) && cd -; \
	done

# Module operations
%_vpc %_rds %_ecs:
	cd $($(shell echo $* | cut -d'_' -f2 | tr a-z A-Z)_MODULE_PATH) && \
	$(TERRAFORM_$(shell echo $* | cut -d'_' -f1 | tr a-z A-Z))

# Common operations
plan apply destroy:
	$(TERRAFORM_$(shell echo $@ | tr a-z A-Z))