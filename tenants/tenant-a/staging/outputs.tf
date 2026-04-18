output "name_prefix" {
  description = "Canonical tenant-project-env name prefix."
  value       = module.tagging.name_prefix
}

output "aws" {
  description = "AWS resource handles."
  value = var.clouds.aws ? {
    bucket_name  = module.aws_storage[0].bucket_name
    bucket_arn   = module.aws_storage[0].bucket_arn
    instance_ids = try(module.aws_compute[0].instance_ids, [])
    public_ips   = try(module.aws_compute[0].public_ips, [])
  } : null
}

output "azure" {
  description = "Azure resource handles."
  value = var.clouds.azure ? {
    resource_group  = module.azure_storage[0].resource_group_name
    storage_account = module.azure_storage[0].storage_account_name
    vm_ids          = try(module.azure_compute[0].vm_ids, [])
    public_ips      = try(module.azure_compute[0].public_ips, [])
  } : null
}

output "gcp" {
  description = "GCP resource handles."
  value = var.clouds.gcp ? {
    bucket_name    = module.gcp_storage[0].bucket_name
    instance_names = try(module.gcp_compute[0].instance_names, [])
    public_ips     = try(module.gcp_compute[0].public_ips, [])
  } : null
}
