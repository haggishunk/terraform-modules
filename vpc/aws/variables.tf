variable "region" {
  type        = "string"
  description = "AWS region selected for deployment"
  default     = "us-west-2"                          # oregon datacenter
}

variable "ssh_key_name" {
  type        = "string"
  description = "SSH key name to be placed on instances"
}

variable "my_ip_cidr" {
  type        = "string"
  description = "CIDR block for inbound SSH management (defaults to anywhere on the internet)"
  default     = "0.0.0.0/0"
}

variable "vpc_name" {
  type        = "string"
  description = "unique name for vpc identification"
}

variable "jumpbox_ami_id" {
  type        = "string"
  description = "AMI id to launch as jumpbox"
}

variable "jumpbox_ami_user" {
  type        = "string"
  description = "AMI-specific user id"
}

variable "jumpbox_sg_ids" {
  type        = "list"
  description = "List of security group ids to append to jumpbox"
}

variable "nat_sg_ids" {
  type        = "list"
  description = "List of security group ids to append to nat"
}
