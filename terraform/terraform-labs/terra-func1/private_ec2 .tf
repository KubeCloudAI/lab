# TOPICS: CONDITION, FOR_EACH (count), LOOKUP, MAP
# Description: Creates private EC2 instances (similar to public-server but without public IPs)

resource "aws_instance" "private-server" {
  # TOPIC: CONDITION - Creates N instances in prod, 1 in other environments
  count = var.environment == "prod" ? length(var.private_cidr_block) : 1

  # TOPIC: LOOKUP - Retrieves AMI ID from MAP based on AWS region
  ami = lookup(var.ami_id, var.aws_region, var.ami_id["us-east-1"])

  instance_type = "t2.micro"
  key_name      = var.key_name

  # TOPIC: FOR_EACH (using count) - Selects private subnet using count.index
  subnet_id = aws_subnet.private-subnet[count.index].id

  # No public IP assigned for private instances
  # associate_public_ip_address = true

  tags = {
    Name        = "${var.vpc_name}-private-server-${count.index + 1}"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}
