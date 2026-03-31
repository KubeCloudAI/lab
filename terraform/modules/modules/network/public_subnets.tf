resource "aws_subnet" "public-subnet" {
  # COUNT: Set to length of list = creates N resources (N subnets)
  count = length(var.public_cidr_block)

  vpc_id = aws_vpc.default.id

  # Format: element(list, index)
  # Gets the CIDR block for this iteration
  cidr_block = element(var.public_cidr_block, count.index + 1)

  # ELEMENT with INDEX - Retrieves AZ from LIST at same index
  availability_zone = element(var.azs, count.index)

  tags = {
    # count.index reflects current iteration (0, 1, 2...) used in naming
    Name        = "${var.vpc_name}-public-subnet-${count.index + 1}"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}
