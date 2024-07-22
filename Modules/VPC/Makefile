# make init
# make apply
# make destroy
# make cache

cache:
	find / -type d  -name ".terraform" -exec rm -rf {} \;


pull:
	git pull

init: pull
	terraform init 

validate: init
	terraform validate 


plan:
	terraform plan

apply:
	terraform apply --auto-approve

destroy:
	terraform destroy --auto-approve