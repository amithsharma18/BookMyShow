output "instance_public_ip" {
  description = "Public IP address of the DevOps box - use this to SSH in and for Ansible inventory"
  value       = aws_instance.devops_box.public_ip
}

output "ssh_command" {
  description = "Ready-to-use SSH command"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.devops_box.public_ip}"
}

output "jenkins_url" {
  description = "Jenkins will be reachable here once Ansible sets it up"
  value       = "http://${aws_instance.devops_box.public_ip}:8080"
}

output "app_url" {
  description = "The app will be reachable here once deployed"
  value       = "http://${aws_instance.devops_box.public_ip}:3000"
}
