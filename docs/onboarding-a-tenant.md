# Onboarding a new tenant

Five steps. Takes about 10 minutes once cloud accounts exist.

## 1. Create the tenant directory

```bash
cp -r tenants/_template tenants/<tenant>
mkdir -p tenants/<tenant>/{dev,staging,prod}
for env in dev staging prod; do
  cp tenants/_template/{backend,main,outputs,providers,variables,versions}.tf \
     tenants/<tenant>/$env/
done
```

## 2. Fill in `terraform.tfvars`

```bash
cp tenants/_template/terraform.tfvars.example tenants/<tenant>/dev/terraform.tfvars
$EDITOR tenants/<tenant>/dev/terraform.tfvars
```

Required:
- `tenant`, `project`, `environment`, `owner`
- `clouds` — which of `aws`, `azure`, `gcp` are enabled
- Per-cloud regions/zones, subscription/project IDs, SSH public keys if
  using compute

## 3. Configure remote state

Edit `tenants/<tenant>/<env>/backend.tf` — uncomment one backend block and
fill in real values. Keep each `(tenant, env)` in its own state key.

## 4. Init, plan, apply

```bash
make init  TENANT=<tenant> ENV=dev
make plan  TENANT=<tenant> ENV=dev
make apply TENANT=<tenant> ENV=dev
```

## 5. Wire Ansible (only if you provisioned compute)

The dynamic inventories pick the hosts up automatically because the modules
tag them with `Tenant`, `Environment`, `Project`, `AnsibleGroup`. Confirm:

```bash
ansible-inventory -i ansible/inventory/aws_ec2.yml \
                  -i ansible/inventory/azure_rm.yml \
                  -i ansible/inventory/gcp_compute.yml \
                  --graph | grep <tenant>
```

Then:

```bash
make ansible-bootstrap TENANT=<tenant> ENV=dev
```

## IAM scoping recommendation

Create a separate IAM role / service principal / GCP service account per
tenant and scope CI/CD credentials to it. Terraform's per-tenant directory
layout makes this clean — the CI job that runs `tenants/tenant-b/prod` only
ever needs tenant-b's prod credentials.
