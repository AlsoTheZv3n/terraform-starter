variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group to place VMs in."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where VMs will be attached."
  type        = string
}

variable "instance_count" {
  description = "Number of VMs to provision."
  type        = number
  default     = 0
}

variable "vm_size" {
  description = "Azure VM SKU."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin user (for SSH from Ansible)."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key string."
  type        = string
}

variable "ansible_group" {
  description = "Value of the `AnsibleGroup` tag. The dynamic inventory keys hosts by this."
  type        = string
  default     = "webservers"
}

variable "tags" {
  description = "Base tags."
  type        = map(string)
  default     = {}
}
