# These can be populated via terraform.tfvars or command-line arguments
variable "vpc_cidr" {}

variable "vpc_name" {}

variable "environment" {}

variable "azs" {}

# Collection of public subnet CIDR blocks
variable "public_cidr_block" {
  type = list(string)
}

# Collection of private subnet CIDR blocks
variable "private_cidr_block" {
  type = list(string)
}
