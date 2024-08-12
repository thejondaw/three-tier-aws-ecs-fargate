# ====================== INSTRUCTIONS ====================== #
#
# make terraform (Install Terraform)
# make init (Initialize the Project)
#
# make all (Apply All Modules)
# - make apply_vpc (Apply VPC Module)
# - make apply_rds (Apply RDS Module)
# - make apply_ecs (Apply ECS Module)
#
# make destroy (Destroy Resources)
# - make destroy_vpc (Destroy VPC Module)
# - make destroy_rds (Destroy RDS Module)
# - make destroy_ecs (Destroy ECS Module)
#
# make cache (Clean Cache)
# ========================================================== #

# Variables
TERRAFORM := terraform
ROOT_DIR := $(shell pwd)
TFVARS_FILE := $(ROOT_DIR)/Terraform.tfvars
TERRAFORM_INIT := $(TERRAFORM) init -var-file=$(TFVARS_FILE)
TERRAFORM_VALIDATE := $(TERRAFORM) validate
TERRAFORM_PLAN := $(TERRAFORM) plan -var-file=$(TFVARS_FILE)
TERRAFORM_APPLY := $(TERRAFORM) apply --auto-approve -var-file=$(TFVARS_FILE)
TERRAFORM_DESTROY := $(TERRAFORM) destroy --auto-approve -var-file=$(TFVARS_FILE)

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
		cd $$module && $(TERRAFORM_INIT) && $(TERRAFORM_VALIDATE) && cd $(ROOT_DIR); \
	done

# Module operations
%_vpc %_rds %_ecs:
	cd $($(shell echo $* | cut -d'_' -f2 | tr a-z A-Z)_MODULE_PATH) && \
	$(TERRAFORM_$(shell echo $* | cut -d'_' -f1 | tr a-z A-Z)) && \
	cd $(ROOT_DIR)

# Common operations
plan apply destroy:
	$(TERRAFORM_$(shell echo $@ | tr a-z A-Z))