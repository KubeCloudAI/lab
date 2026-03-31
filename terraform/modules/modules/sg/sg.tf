# Description: Creates security group with dynamic ingress rules using FOR_EACH pattern
# Demonstrates how to create multiple similar blocks programmatically

resource "aws_security_group" "allow_all" {
  name        = "${var.vpc_name}-allow-all"
  description = "Allow all inbound traffic"
  vpc_id      = var.vpc_id

  # Creates a separate 'ingress' block for each port in var.ingress_ports list
  # Each iteration accessible via 'ingress.value' (the port number)
  dynamic "ingress" {
    for_each = var.ingress_value # LIST: iterable collection of port numbers
    content {
      from_port   = ingress.value # Current iteration value (port number)
      to_port     = ingress.value # Current iteration value (port number)
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-allow-all"
    Environment = "${var.environment}"
  }
}
