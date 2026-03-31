
# Description: Creates EC2 instances with dynamic resource naming based on environment
resource "aws_instance" "public-server" {
  count                       = var.environment == "prod" ? 3 : 1
  ami                         = lookup(var.amis, var.aws_region)
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.public_subnets[count.index]
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.vpc_name}-public-server-${count.index + 1}"
    # Owner       = "${local.owner}"
    # costcenter  = "${local.costcenter}"
    # Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
  user_data = <<-EOF
#!/bin/bash
sudo apt update
sudo apt install -y nginx git
sudo git clone https://github.com/saikiranpi/SecOps-game.git /tmp/SecOps-game || true
sudo cp /tmp/SecOps-game/index.html /var/www/html/index.html
echo "<h1>${var.vpc_name}-public-Server-${count.index + 1}</h1>" >> /var/www/html/index.html
systemctl enable nginx
systemctl restart nginx
EOF
}
