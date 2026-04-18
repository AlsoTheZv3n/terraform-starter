variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "suffix" {
  description = "Random suffix for globally unique names."
  type        = string
}

variable "location" {
  description = "GCS location, e.g. EU, US, europe-west6."
  type        = string
  default     = "EU"
}

variable "labels" {
  description = "Labels applied to every resource (GCP-safe: lowercase)."
  type        = map(string)
  default     = {}
}
