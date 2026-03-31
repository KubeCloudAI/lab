resource "aws_instance" "public-servers" {
  count                       = var.environment == "Production" ? 3 : 3
  ami                         = lookup(var.amis, var.aws_region)
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = element(var.public_subnets, count.index)
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true
  tags = {
    Name        = "${var.vpc_name}-Public-Server-${count.index + 1}"
    environment = "${var.environment}"
  }
  user_data  = <<-EOF
#!/bin/bash
sudo apt update
sudo apt install -y nginx git
sudo git clone https://github.com/saikiranpi/SecOps-game.git /tmp/SecOps-game || true
sudo cp /tmp/SecOps-game/index.html /var/www/html/index.html
echo "<h1>${var.vpc_name}-public-Server-${count.index + 1}</h1>" >> /var/www/html/index.html
systemctl enable nginx
systemctl restart nginx
EOF
  depends_on = [var.elb_listener_public]
}
