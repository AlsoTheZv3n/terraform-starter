# Multi-cloud multi-tenant Terraform + Ansible helper.
#
# Usage examples:
#   make fmt
#   make validate TENANT=tenant-a ENV=dev
#   make plan     TENANT=tenant-a ENV=dev
#   make apply    TENANT=tenant-a ENV=dev
#   make destroy  TENANT=tenant-a ENV=dev
#   make ansible-bootstrap TENANT=tenant-a ENV=dev

TENANT ?= tenant-a
ENV    ?= dev
STACK  := tenants/$(TENANT)/$(ENV)

TF       ?= terraform
ANSIBLE  ?= ansible-playbook

.PHONY: help fmt validate init plan apply destroy lint ansible-bootstrap ansible-deploy

help:
	@echo "Targets:"
	@echo "  fmt                    terraform fmt -recursive"
	@echo "  validate               terraform validate in $$STACK"
	@echo "  init                   terraform init in $$STACK"
	@echo "  plan                   terraform plan in $$STACK"
	@echo "  apply                  terraform apply in $$STACK"
	@echo "  destroy                terraform destroy in $$STACK"
	@echo "  ansible-bootstrap      run bootstrap.yml against this tenant/env"
	@echo "  ansible-deploy         run deploy_app.yml against this tenant/env"

fmt:
	$(TF) fmt -recursive

init:
	cd $(STACK) && $(TF) init

validate: init
	cd $(STACK) && $(TF) validate

plan:
	cd $(STACK) && $(TF) plan -out=tfplan

apply:
	cd $(STACK) && $(TF) apply tfplan

destroy:
	cd $(STACK) && $(TF) destroy

lint:
	@command -v tflint >/dev/null && tflint --recursive || echo "tflint not installed, skipping"
	@command -v tfsec  >/dev/null && tfsec .               || echo "tfsec not installed, skipping"

ANSIBLE_INV := -i ansible/inventory/aws_ec2.yml -i ansible/inventory/azure_rm.yml -i ansible/inventory/gcp_compute.yml
ANSIBLE_LIMIT := --limit "tenant_$(subst -,_,$(TENANT)):&env_$(ENV)"

ansible-bootstrap:
	cd $(CURDIR) && $(ANSIBLE) $(ANSIBLE_INV) ansible/playbooks/bootstrap.yml $(ANSIBLE_LIMIT)

ansible-deploy:
	cd $(CURDIR) && $(ANSIBLE) $(ANSIBLE_INV) ansible/playbooks/deploy_app.yml $(ANSIBLE_LIMIT)
