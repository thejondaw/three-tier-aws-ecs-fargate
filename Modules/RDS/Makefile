# ==================================================== #

# "make cache"
cache:
	find / -type d  -name ".terraform" -exec rm -rf {} \;

# =================== "make init" ==================== #

pull:
	git pull

init: pull
	terraform init 

validate: init
	terraform validate 

# ==================================================== #

# "make plan"
plan:
	terraform plan

# "make apply"
apply:
	terraform apply --auto-approve

# "make destroy"
destroy:
	terraform destroy --auto-approve

# ==================================================== #