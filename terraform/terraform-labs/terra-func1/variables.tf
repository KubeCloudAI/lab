# VARIABLE DEFINITIONS - Used throughout the configuration
# These can be populated via terraform.tfvars or command-line arguments

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {}

variable "vpc_name" {}

variable "key_name" {
  type    = string
  default = "dev-mentor-keypair"
}

variable "azs" {}

# TOPIC: LIST - Collection of public subnet CIDR blocks
variable "public_cidr_block" {
  type = list(string)
}

# TOPIC: LIST - Collection of private subnet CIDR blocks
variable "private_cidr_block" {
  type = list(string)
}

variable "environment" {}

# TOPIC: LIST - Collection of port numbers for ingress rules
variable "ingress_ports" {
  type = list(number)
}

# TOPIC: MAP - Maps region to AMI ID (used with LOOKUP function)
variable "ami_id" {}
