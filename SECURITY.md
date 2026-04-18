# Security Policy

## Reporting a vulnerability

If you find a security issue in this template, **do not open a public GitHub
issue**. Instead, open a private security advisory via the repository's
"Security" tab (`/security/advisories/new`) or email the maintainer.

Please include:

- Affected files / modules
- Steps to reproduce or a proof-of-concept
- Impact assessment (what an attacker could do)

You can expect an acknowledgement within a few working days.

## Scope

This is an infrastructure **template**. The threat model is:

- **In scope**: hardcoded secrets, insecure defaults (public buckets, weak
  TLS, missing encryption), dynamic inventories that expand beyond their
  intended filter, privilege escalation in example roles.
- **Out of scope**: misconfiguration in a user's fork after they've
  customised it, issues specific to third-party modules you pull in.

## Secrets handling — how this repo expects you to work

**No secrets live in this repo.** Everything sensitive flows in from outside:

| Type                       | Source                                                    |
|----------------------------|-----------------------------------------------------------|
| AWS credentials            | `aws configure sso` / IAM role / OIDC from CI             |
| Azure credentials          | `az login` / workload identity federation / `AZURE_*` env |
| GCP credentials            | `gcloud auth application-default login` / workload identity |
| `terraform.tfvars`         | Never committed. See `*.example` files for shape          |
| SSH private keys           | Your machine / CI runner only. Public keys go in tfvars   |
| Application secrets        | AWS SSM, Azure Key Vault, GCP Secret Manager — referenced via data sources |

### What's gitignored

See [.gitignore](.gitignore). In particular:

- `*.tfvars` and `*.tfvars.json` — only `*.tfvars.example` tracked
- `*.tfstate*` — state files can contain resolved secrets
- `.terraform/` — provider binaries and cached modules
- `*.pem`, `*.key`, `id_rsa*` — private keys
- `ansible/collections/` — installed collections

### Pre-commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) runs `detect-private-key`
on every commit. Install hooks once:

```bash
pre-commit install
```

### If you accidentally commit a secret

1. **Rotate the secret immediately** at the source (AWS, Azure, GCP console).
2. Remove it from history (`git filter-repo` or BFG). `git rm` is not enough
   — the blob stays in history.
3. Force-push only after confirming no other collaborators have work on top.

## Hardened defaults in this template

- S3 buckets: AES256 encryption, versioning, public access fully blocked,
  ACLs disabled (BucketOwnerEnforced).
- Azure Storage: TLS 1.2 minimum, HTTPS only, public blob access disabled,
  blob versioning + 7-day soft delete.
- GCS: uniform bucket-level access, public access prevention enforced,
  versioning with lifecycle cleanup.
- EC2: IMDSv2 required, encrypted root volume.
- Azure VMs: SSH-key only, password auth disabled.
- Tagging: every resource carries `ManagedBy=terraform` so dynamic
  inventories ignore manually-created hosts.
