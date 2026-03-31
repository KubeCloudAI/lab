resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name        = "${var.vpc_name}-public route-table"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}


resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name        = "${var.vpc_name}-private route-table"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}


# Description: Associates subnets to route tables using COUNT iteration

# COUNT with SPLAT SYNTAX - Creates association for each public subnet
# aws_subnet.public-subnet.*.id produces a list of all public subnet IDs
resource "aws_route_table_association" "public-subnets" {
  # COUNT: Creates N associations, one for each subnet in the list
  count = length(aws_subnet.public-subnet.*.id)

  # INDEX - References specific subnet by its count index
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}

# COUNT with SPLAT SYNTAX - Creates association for each private subnet
resource "aws_route_table_association" "private-subnets" {
  # COUNT: Creates N associations, one for each subnet
  count = length(aws_subnet.private-subnet.*.id)

  # INDEX - References specific private subnet using count.index
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-route-table.id
}
