# TOPICS: FOR_EACH (COUNT), LIST, INDEX, ELEMENT
# Description: Creates multiple subnets using COUNT to iterate over LISTS of CIDR blocks

# TOPIC: FOR_EACH (using COUNT) - Create multiple resources from a single resource block
# count determines HOW MANY resources to create
# count.index provides the current iteration number (0, 1, 2...)
# element() function retrieves a value from a LIST at a specific index
resource "aws_subnet" "public-subnet" {
  # COUNT: Set to length of list = creates N resources (N subnets)
  count = length(var.public_cidr_block)
  
  vpc_id = aws_vpc.default.id

  # TOPIC: ELEMENT function - Retrieves value from LIST at specific INDEX
  # Format: element(list, index)
  # Gets the CIDR block for this iteration
  cidr_block = element(var.public_cidr_block, count.index)

  # TOPIC: ELEMENT with INDEX - Retrieves AZ from LIST at same index
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

# TOPIC: FOR_EACH (using COUNT) - Create private subnets similarly
resource "aws_subnet" "private-subnet" {
  # COUNT: Creates N private subnets matching private CIDR blocks
  count = length(var.private_cidr_block)
  
  vpc_id = aws_vpc.default.id

  # TOPIC: ELEMENT - Gets private CIDR for this iteration
  cidr_block = element(var.private_cidr_block, count.index)

  # TOPIC: ELEMENT with INDEX - Matches AZ to public subnets for consistency
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${count.index + 1}"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}
