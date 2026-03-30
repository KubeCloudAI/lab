# TOPICS: CONDITION, FOR_EACH (count), LOOKUP, MAP
# Description: Creates EC2 instances with dynamic resource naming based on environment
resource "aws_instance" "public-server" {
  # TOPIC: CONDITION (Ternary Operator)
  # If environment is 'prod', create N instances (length of list), otherwise create 1
  # Condition Format: var.environment == "prod" ? true_value : false_value
  count = var.environment == "prod" ? length(var.public_cidr_block) : 1

  # TOPIC: LOOKUP - Retrieves AMI ID from MAP (ami_id variable)
  # Searches ami_id MAP for current AWS region, defaults to us-east-1 if not found
  # Format: lookup(map, key, default_value)
  ami = lookup(var.ami_id, var.aws_region, var.ami_id["us-east-1"])

  instance_type               = "t2.micro"
  key_name                    = var.key_name

  # TOPIC: FOR_EACH (using count)
  # count.index provides the current iteration (0, 1, 2...)
  # Dynamically selects subnet for each instance based on index
  subnet_id = aws_subnet.public-subnet[count.index].id

  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true

  # TOPIC: TEMPLATEFILE - Renders user_data.sh.tftpl with variables
  user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    vpc_name       = var.vpc_name
    instance_index = count.index + 1
  })

  lifecycle {
    # Prevent Terraform from recreating the instance when only user_data changes
    ignore_changes = [user_data]
  }

  tags = {
    Name        = "${var.vpc_name}-public-server-${count.index + 1}"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}
