variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "zone" {
  description = "GCP zone, e.g. europe-west6-a."
  type        = string
}

variable "instance_count" {
  description = "Number of instances."
  type        = number
  default     = 0
}

variable "machine_type" {
  description = "GCE machine type."
  type        = string
  default     = "e2-small"
}

variable "network" {
  description = "Self-link or name of the VPC network."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Self-link or name of the subnetwork."
  type        = string
  default     = null
}

variable "ssh_user" {
  description = "SSH username injected via metadata (used by Ansible)."
  type        = string
  default     = "ansible"
}

variable "ssh_public_key" {
  description = "SSH public key string."
  type        = string
}

variable "ansible_group" {
  description = "Value of the `ansible-group` label. The dynamic inventory keys hosts by this."
  type        = string
  default     = "webservers"
}

variable "labels" {
  description = "Base labels. `ansible-group` is added automatically."
  type        = map(string)
  default     = {}
}
