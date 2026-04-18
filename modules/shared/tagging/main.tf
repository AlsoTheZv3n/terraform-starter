locals {
  base = {
    Tenant      = var.tenant
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    ManagedBy   = "terraform"
  }

  aws_tags   = merge(local.base, var.extra)
  azure_tags = merge(local.base, var.extra)

  gcp_labels = {
    for k, v in merge(local.base, var.extra) :
    lower(k) => lower(replace(v, "/[^a-z0-9_-]/", "-"))
  }

  name_prefix = "${var.tenant}-${var.project}-${var.environment}"
}
