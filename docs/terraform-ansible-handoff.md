# Terraform → Ansible handoff

The handoff is **tag/label-based dynamic inventory**, not static files. This
doc defines the contract. Break the contract → Ansible stops finding hosts.

## Contract

Every compute resource Terraform creates carries these tags (AWS, Azure) or
labels (GCP):

| Key            | Source                         | Example            |
|----------------|--------------------------------|--------------------|
| `Tenant`       | `var.tenant`                   | `tenant-a`         |
| `Environment`  | `var.environment`              | `prod`             |
| `Project`      | `var.project`                  | `platform`         |
| `Owner`        | `var.owner`                    | `platform-team`    |
| `ManagedBy`    | hardcoded to `terraform`       | `terraform`        |
| `AnsibleGroup` | per-module, default `webservers` | `platform-web`   |

GCP lowercases keys (`tenant`, `environment`, etc.) and sanitises values —
see [modules/shared/tagging/main.tf](../modules/shared/tagging/main.tf).

## What the inventories produce

Running:

```bash
ansible-inventory -i ansible/inventory/aws_ec2.yml --graph
```

produces groups like:

```
  |--@tenant_tenant_a
  |--@env_prod
  |--@project_platform
  |--@group_platform_web
```

Intersections work with `ansible-playbook --limit "tenant_tenant_a:&env_prod"`.

## Adding a new cloud

1. Create a `modules/<cloud>/compute/` that applies the same tag contract
   (adjusting for the cloud's constraints — GCP only accepts lowercase
   labels, for example).
2. Add an inventory plugin file in `ansible/inventory/<cloud>_*.yml` using
   the same `keyed_groups` structure.
3. Done. No Ansible playbook or role changes needed.

## Why not `terraform output` → static inventory

- Race condition: inventory goes stale the moment anything auto-scales.
- State coupling: Ansible would need access to every tenant's tfstate.
- Cross-cloud hosts: one command would have to merge N outputs.

Dynamic inventory plugins read directly from cloud APIs, filter by
`ManagedBy=terraform`, and work identically whether you have 3 VMs or 300.
