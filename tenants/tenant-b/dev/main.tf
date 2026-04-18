module "tagging" {
  source = "../../modules/shared/tagging"

  tenant      = var.tenant
  project     = var.project
  environment = var.environment
  owner       = var.owner
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# -------------------- AWS --------------------
module "aws_storage" {
  count  = var.clouds.aws ? 1 : 0
  source = "../../modules/aws/storage"

  name_prefix = module.tagging.name_prefix
  suffix      = random_string.suffix.result
  tags        = module.tagging.aws_tags
}

module "aws_compute" {
  count  = var.clouds.aws && var.aws_instance_count > 0 ? 1 : 0
  source = "../../modules/aws/compute"

  name_prefix    = module.tagging.name_prefix
  instance_count = var.aws_instance_count
  subnet_id      = var.aws_subnet_id
  key_name       = var.aws_key_name
  ansible_group  = "${var.project}-web"
  tags           = module.tagging.aws_tags
}

# -------------------- Azure --------------------
module "azure_storage" {
  count  = var.clouds.azure ? 1 : 0
  source = "../../modules/azure/storage"

  name_prefix = module.tagging.name_prefix
  suffix      = random_string.suffix.result
  location    = var.azure_location
  tags        = module.tagging.azure_tags
}

module "azure_compute" {
  count  = var.clouds.azure && var.azure_instance_count > 0 ? 1 : 0
  source = "../../modules/azure/compute"

  name_prefix         = module.tagging.name_prefix
  resource_group_name = module.azure_storage[0].resource_group_name
  location            = var.azure_location
  subnet_id           = var.azure_subnet_id
  instance_count      = var.azure_instance_count
  ssh_public_key      = var.azure_ssh_public_key
  ansible_group       = "${var.project}-web"
  tags                = module.tagging.azure_tags
}

# -------------------- GCP --------------------
module "gcp_storage" {
  count  = var.clouds.gcp ? 1 : 0
  source = "../../modules/gcp/storage"

  name_prefix = module.tagging.name_prefix
  suffix      = random_string.suffix.result
  location    = var.gcp_location
  labels      = module.tagging.gcp_labels
}

module "gcp_compute" {
  count  = var.clouds.gcp && var.gcp_instance_count > 0 ? 1 : 0
  source = "../../modules/gcp/compute"

  name_prefix    = module.tagging.name_prefix
  zone           = var.gcp_zone
  instance_count = var.gcp_instance_count
  ssh_public_key = var.gcp_ssh_public_key
  ansible_group  = "${var.project}-web"
  labels         = module.tagging.gcp_labels
}
