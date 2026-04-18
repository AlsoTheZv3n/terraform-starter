variable "tenant" {
  description = "Tenant identifier."
  type        = string
}

variable "project" {
  description = "Project name within the tenant."
  type        = string
}

variable "environment" {
  description = "dev | staging | prod."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}

variable "owner" {
  description = "Team or person owning this stack."
  type        = string
}

variable "clouds" {
  description = "Which cloud providers to deploy in this tenant/env."
  type = object({
    aws   = optional(bool, true)
    azure = optional(bool, true)
    gcp   = optional(bool, false)
  })
  default = {}
}

# ---- AWS ----
variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_instance_count" {
  type    = number
  default = 0
}

variable "aws_subnet_id" {
  type    = string
  default = null
}

variable "aws_key_name" {
  type    = string
  default = null
}

# ---- Azure ----
variable "azure_location" {
  type    = string
  default = "switzerlandnorth"
}

variable "azure_subscription_id" {
  type    = string
  default = null
}

variable "azure_instance_count" {
  type    = number
  default = 0
}

variable "azure_subnet_id" {
  type    = string
  default = null
}

variable "azure_ssh_public_key" {
  type    = string
  default = ""
}

# ---- GCP ----
variable "gcp_project_id" {
  type    = string
  default = null
}

variable "gcp_region" {
  type    = string
  default = "europe-west6"
}

variable "gcp_zone" {
  type    = string
  default = "europe-west6-a"
}

variable "gcp_location" {
  description = "GCS location (multi-region or region)."
  type        = string
  default     = "EU"
}

variable "gcp_instance_count" {
  type    = number
  default = 0
}

variable "gcp_ssh_public_key" {
  type    = string
  default = ""
}
