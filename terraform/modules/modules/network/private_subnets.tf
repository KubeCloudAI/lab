# FOR_EACH (using COUNT) - Create private subnets similarly
resource "aws_subnet" "private-subnet" {
  # COUNT: Creates N private subnets matching private CIDR blocks
  count = length(var.private_cidr_block)

  vpc_id = aws_vpc.default.id

  # ELEMENT - Gets private CIDR for this iteration
  cidr_block = element(var.private_cidr_block, count.index + 1)

  # ELEMENT with INDEX - Matches AZ to public subnets for consistency
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${count.index + 1}"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}
