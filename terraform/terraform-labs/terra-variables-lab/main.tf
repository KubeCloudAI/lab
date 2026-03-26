# Configure the AWS provider for us-east-1 region
provider "aws" {
  region = var.region_name
}

# Create Virtual Private Cloud with DNS support enabled
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpc_tag_name
    Service = "Terraform"
  }
}

# Create public subnet in the VPC with automatic public IP assignment
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_az

  tags = {
    Name    = var.subnet_tag_name
    Service = "Terraform"
  }
}

# Create Internet Gateway to enable internet connectivity for VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = var.igw_tag
    Service = "Terraform"
  }
}

# Create public route table directing all traffic to the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Route all outbound traffic through the IGW
  route {
    cidr_block = var.rt_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = var.rt_tag
    Service = "Terraform"
  }
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create security group allowing all inbound and outbound traffic (permissive for demo/lab)
resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id

  # Allow all inbound traffic on all protocols and ports
  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access (port 22) from anywhere
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic on all protocols and ports
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "SG-Terra"
    Service = "Terraform"
  }
}

resource "aws_instance" "web-1" {
  ami                         = "ami-0ec10929233384c7f" # Ubuntu 20.04 LTS AMI
  availability_zone           = var.ec2_az
  instance_type               = var.ec2_type                           # Free tier eligible
  key_name                    = var.key_pair_name                      # SSH keypair for remote access
  subnet_id                   = aws_subnet.public.id                   # Deploy in public subnet
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"] # Apply security group
  associate_public_ip_address = true                                   # Assign public IP address
  tags = {
    Name       = "Prod-Server"
    Env        = "Prod"
    Owner      = "necromonger"
    CostCenter = "tesla"
  }
  #   lifecycle {
  #     create_before_destroy = true
  #   }
  #   #   lifecycle {
  #   #     prevent_destroy = true
  #   #   }
}

