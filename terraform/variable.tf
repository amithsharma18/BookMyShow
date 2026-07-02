variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
  default     = "xxx"
}

variable "instance_names" {
  description = "Names/tags for the EC2 instances to create"
  type        = list(string)
  default     = ["BMS-server", "k8smaster", "k8sworker"]
}