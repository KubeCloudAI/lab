resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
    # TOPIC: LOCALS - Values from local.tf for consistent tag management
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}


resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}
