variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "suffix" {
  description = "Random suffix for globally unique names."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
