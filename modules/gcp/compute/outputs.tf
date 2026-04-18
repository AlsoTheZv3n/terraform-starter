output "instance_names" {
  description = "Names of the GCE instances."
  value       = google_compute_instance.this[*].name
}

output "public_ips" {
  description = "Ephemeral public IPs."
  value       = [for vm in google_compute_instance.this : vm.network_interface[0].access_config[0].nat_ip]
}

output "private_ips" {
  description = "Private IPs."
  value       = [for vm in google_compute_instance.this : vm.network_interface[0].network_ip]
}
