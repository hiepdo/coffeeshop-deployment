variable "env" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}

variable "ami" {
  description = "EC2 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for EC2"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
}
