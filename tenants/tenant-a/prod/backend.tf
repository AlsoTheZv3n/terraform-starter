# Remote state per tenant + environment.
#
# Pick ONE backend and fill in real values, then run:
#   terraform init -backend-config=backend.hcl
#
# Keeping tenants in separate state files is intentional: one tenant's
# `terraform destroy` can never touch another tenant's resources.

terraform {
  # ---- AWS S3 backend (recommended if you already run on AWS) ----
  # backend "s3" {
  #   bucket         = "CHANGEME-tfstate"
  #   key            = "tenants/<tenant>/<env>/terraform.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }

  # ---- Azure Storage backend ----
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "CHANGEMEtfstate"
  #   container_name       = "tfstate"
  #   key                  = "tenants/<tenant>/<env>.tfstate"
  # }

  # ---- GCS backend ----
  # backend "gcs" {
  #   bucket = "CHANGEME-tfstate"
  #   prefix = "tenants/<tenant>/<env>"
  # }
}
