# =================== INSTRUCTIONS =================== #

# make check-tools (Check for required tools)
# make terraform (Install Terraform)
# make init (Initialize the Project)
# make fmt (Check Terraform formatting)
# make cache (Clean Cache)

# make plan (Plan All Resources)
# make apply (Apply All Resources)
# make destroy (Destroy All Resources)

# ==================== VARIABLES ====================== #

TERRAFORM := terraform
ROOT_DIR := $(shell pwd)
TFVARS_FILE := $(ROOT_DIR)/Terraform.tfvars
TERRAFORM_INIT := $(TERRAFORM) init
TERRAFORM_VALIDATE := $(TERRAFORM) validate
TERRAFORM_PLAN := $(TERRAFORM) plan -var-file=$(TFVARS_FILE)
TERRAFORM_APPLY := $(TERRAFORM) apply --auto-approve -var-file=$(TFVARS_FILE)
TERRAFORM_DESTROY := $(TERRAFORM) destroy --auto-approve -var-file=$(TFVARS_FILE)

# ===================== TARGETS ======================= #

.PHONY: check-tools terraform init fmt cache plan apply destroy

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
	git pull
	$(TERRAFORM_INIT)
	$(TERRAFORM_VALIDATE)

fmt:
	@echo "Checking Terraform formatting..."
	$(TERRAFORM) fmt -check -recursive
	@echo "Terraform formatting check passed."

cache:
	find . -type d -name ".terraform" -exec rm -rf {} +
	rm -rf $$HOME/.terraform.d/plugin-cache/*

# ================= PLAN OPERATION ==================== #

plan:
	@echo "Planning all resources..."
	$(TERRAFORM_PLAN)

# ================ APPLY OPERATION ==================== #

apply:
	@echo "Applying all resources..."
	$(TERRAFORM_APPLY)

# =============== DESTROY OPERATION =================== #

destroy:
	@echo "Destroying all resources..."
	$(TERRAFORM_DESTROY)