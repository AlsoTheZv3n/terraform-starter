output "aws_tags" {
  description = "Tag map for AWS resources."
  value       = local.aws_tags
}

output "azure_tags" {
  description = "Tag map for Azure resources."
  value       = local.azure_tags
}

output "gcp_labels" {
  description = "Label map for GCP resources (lowercased, GCP-safe)."
  value       = local.gcp_labels
}

output "name_prefix" {
  description = "Canonical name prefix: tenant-project-env."
  value       = local.name_prefix
}
