# Terraform Configuration for VPC Infrastructure
# This code demonstrates several Terraform features: Locals, Maps, Conditions, Count, Lookup, etc.

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "sachindevops123465"
    key    = "development.statefile"
    region = "us-east-1"
  }
}
