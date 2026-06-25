variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-1" # Mumbai - closest region for India
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t2.micro" # Free tier eligible - no AWS charges
}

variable "key_name" {
  description = "Name of the existing AWS EC2 key pair to use for SSH access"
  type        = string
}

variable "my_ip" {
  description = "Your public IP address in CIDR format, e.g. 1.2.3.4/32 (used to restrict SSH access)"
  type        = string
}

variable "app_name" {
  description = "Name tag for resources"
  type        = string
  default     = "bookmyshow-devops"
}
