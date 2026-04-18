variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "instance_count" {
  description = "How many EC2 instances to provision."
  type        = number
  default     = 0
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet the instances will run in. Pass the default VPC subnet if unsure."
  type        = string
  default     = null
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH access (used by Ansible)."
  type        = string
  default     = null
}

variable "ansible_group" {
  description = "Value of the `AnsibleGroup` tag. The dynamic inventory keys hosts by this."
  type        = string
  default     = "webservers"
}

variable "tags" {
  description = "Base tags. `Name` and `AnsibleGroup` are added automatically."
  type        = map(string)
  default     = {}
}
