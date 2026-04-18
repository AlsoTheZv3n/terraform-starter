output "instance_ids" {
  description = "IDs of the EC2 instances."
  value       = aws_instance.this[*].id
}

output "public_ips" {
  description = "Public IPs (may be empty in private subnets)."
  value       = aws_instance.this[*].public_ip
}

output "private_ips" {
  description = "Private IPs of the EC2 instances."
  value       = aws_instance.this[*].private_ip
}
