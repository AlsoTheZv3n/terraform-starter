variable "tenant" {
  description = "Tenant identifier. Becomes part of every resource tag/label."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,30}$", var.tenant))
    error_message = "tenant must be 2-30 chars, lowercase/digits/hyphens only."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging or prod."
  }
}

variable "project" {
  description = "Project name within the tenant."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,30}$", var.project))
    error_message = "project must be 2-30 chars, lowercase/digits/hyphens only."
  }
}

variable "owner" {
  description = "Owning team or person."
  type        = string
}

variable "extra" {
  description = "Optional extra tags/labels merged on top."
  type        = map(string)
  default     = {}
}
