output "instance_ids" {
  description = "Instance IDs of all created EC2 instances"
  value       = { for k, v in aws_instance.servers : k => v.id }
}

output "instance_public_ips" {
  description = "Public IPs of all created EC2 instances"
  value       = { for k, v in aws_instance.servers : k => v.public_ip }
}

output "ssh_connection_links" {
  description = "Ready-to-use SSH commands for each instance"
  value       = { for k, v in aws_instance.servers : k => "ssh -i ${var.key_name}.pem ubuntu@${v.public_ip}" }
}