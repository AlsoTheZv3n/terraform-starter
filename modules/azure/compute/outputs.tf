output "vm_ids" {
  description = "IDs of the VMs."
  value       = azurerm_linux_virtual_machine.this[*].id
}

output "public_ips" {
  description = "Public IPs of the VMs."
  value       = azurerm_public_ip.this[*].ip_address
}

output "private_ips" {
  description = "Private IPs of the VMs."
  value       = azurerm_linux_virtual_machine.this[*].private_ip_address
}
