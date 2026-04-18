# Multi-Cloud Multi-Tenant Terraform + Ansible

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9-623CE4)](https://www.terraform.io/)
[![Clouds](https://img.shields.io/badge/Clouds-AWS%20%7C%20Azure%20%7C%20GCP-informational)](#)

Starter repo for provisioning infrastructure across **AWS, Azure, and GCP** for
multiple tenants and environments, then configuring the hosts with **Ansible**
through dynamic inventories driven by tags/labels Terraform sets.

> No secrets live in this repo. Every `terraform.tfvars` is an `.example` —
> see [SECURITY.md](./SECURITY.md) for the secrets-handling model.

## Layout

```
terraform-starter/
├── LICENSE                          # MIT
├── SECURITY.md                      # Secrets model + disclosure policy
├── Makefile                         # fmt / validate / plan / apply / ansible wrappers
├── .pre-commit-config.yaml          # tflint, tfsec, ansible-lint, detect-private-key
├── .gitignore
│
├── modules/                         # reusable, cloud-scoped
│   ├── shared/tagging/              # single source of truth for tags & labels
│   ├── aws/{storage,compute}/
│   ├── azure/{storage,compute}/
│   └── gcp/{storage,compute}/
│
├── tenants/                         # one state file per tenant/env
│   ├── _template/                   # scaffold — copy to onboard a new tenant
│   ├── tenant-a/{dev,staging,prod}/
│   └── tenant-b/{dev}/
│
├── ansible/
│   ├── ansible.cfg
│   ├── requirements.yml             # amazon.aws, azure.azcollection, google.cloud
│   ├── inventory/                   # dynamic inventories (aws_ec2, azure_rm, gcp_compute)
│   ├── playbooks/                   # site.yml, bootstrap.yml, deploy_app.yml
│   └── roles/                       # common, webserver
│
└── docs/
    ├── onboarding-a-tenant.md
    └── terraform-ansible-handoff.md
```

## Key design decisions

- **Tenant isolation via directories + per-tenant remote state.** No workspaces.
  One tenant's `destroy` can never touch another tenant.
- **Environment per sub-directory.** Same reasoning. Workspaces share a backend.
- **Single tagging module** produces `aws_tags`, `azure_tags`, `gcp_labels` from
  one `{tenant, environment, project, owner}` input. GCP labels are auto
  lowercased/sanitised because GCP is pickier than AWS/Azure.
- **Ansible finds hosts via dynamic inventory**, not static IP lists. Terraform
  sets tags (`Tenant`, `Environment`, `Project`, `AnsibleGroup`) and the
  inventory plugins key groups off those — so spinning up a new VM in
  `tenant-a/prod` auto-appears in the `tenant_tenant_a:&env_prod` group.
- **`ManagedBy=terraform` tag/label filter** keeps hand-created resources out of
  Ansible's blast radius.
- **Zero secrets in the repo.** All credentials flow in from `az login` / AWS
  SSO / GCP ADC / CI OIDC. `terraform.tfvars` is git-ignored; only `.example`
  files are tracked.

## Quick start — `tenant-a/dev`

```bash
# 1. Fork / clone
git clone https://github.com/<you>/terraform-starter.git
cd terraform-starter

# 2. Create your local tfvars from the example (git-ignored)
cp tenants/tenant-a/dev/terraform.tfvars.example \
   tenants/tenant-a/dev/terraform.tfvars
$EDITOR tenants/tenant-a/dev/terraform.tfvars

# 3. Authenticate to the cloud(s) you've enabled
aws sso login                                    # if clouds.aws = true
az login                                         # if clouds.azure = true
gcloud auth application-default login            # if clouds.gcp = true

# 4. Configure a remote state backend in backend.tf, then init/plan/apply
make init    TENANT=tenant-a ENV=dev
make plan    TENANT=tenant-a ENV=dev
make apply   TENANT=tenant-a ENV=dev

# 5. Install Ansible collections (once)
ansible-galaxy install -r ansible/requirements.yml

# 6. Run Ansible against the tenant
make ansible-bootstrap TENANT=tenant-a ENV=dev
make ansible-deploy    TENANT=tenant-a ENV=dev
```

## Onboarding a new tenant

See [docs/onboarding-a-tenant.md](docs/onboarding-a-tenant.md) — one-page runbook.

## Terraform → Ansible handoff

See [docs/terraform-ansible-handoff.md](docs/terraform-ansible-handoff.md) for
the exact tag/label contract the inventories depend on.

## Pre-commit hooks

```bash
pip install pre-commit
pre-commit install
```

Runs on every commit: `terraform fmt`, `terraform validate`, `tflint`,
`tfsec`, `ansible-lint`, plus `detect-private-key` and YAML hygiene. See
[.pre-commit-config.yaml](./.pre-commit-config.yaml).

## Next steps for production

- Fill in a real backend in each tenant's `backend.tf` (blocks commented in
  the template).
- Wire `make lint` (tflint + tfsec) into CI; block merges on failures.
- Add network modules (VPC/VNet/GCP VPC) — current compute modules take a
  pre-existing subnet to stay small.
- Move app-level secrets to AWS SSM / Azure Key Vault / GCP Secret Manager
  and reference them with data sources, not variables.
- Customer-managed encryption keys instead of platform defaults.
- Private endpoints for storage; audit logging (CloudTrail / Azure Monitor /
  GCP Audit Logs).
- OIDC federation from GitHub Actions → cloud providers (no static keys in CI).

## Security

See [SECURITY.md](./SECURITY.md) for the secrets model, disclosure policy,
and the list of hardened defaults shipped in the modules.

## Contributing

Pull requests welcome. Please:

1. Run `pre-commit run --all-files` before pushing.
2. Keep modules cloud-scoped — no `if provider == "aws"` branches.
3. Add/update the tag contract in [docs/terraform-ansible-handoff.md](docs/terraform-ansible-handoff.md) if you touch tagging.

## License

[MIT]
