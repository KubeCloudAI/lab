# RDS Database Configuration

# Retrieve the secret containing the database password from AWS Secrets Manager
data "aws_secretsmanager_secret" "db_secret" {
  name = "prod-db-password"
}

# Fetch the actual password value from the secret version
data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}

# Create a subnet group spanning multiple availability zones for high availability
resource "aws_db_subnet_group" "prod_subnet_group" {
  name = "prod-db-subnet-group"
  subnet_ids = [
    aws_subnet.subnet1-public.id,
    aws_subnet.subnet2-public.id,
    aws_subnet.subnet3-public.id
  ]

  tags = {
    Name = "Production DB Subnet Group"
  }
}

# Create the RDS MySQL database instance for production use
resource "aws_db_instance" "prod_db_instance" {
  identifier        = "proddb"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.4.8"
  instance_class    = "db.t3.medium"
  db_name           = "prod_db"
  username          = "adminuser"
  # Retrieve password securely from AWS Secrets Manager instead of hardcoding
  password             = data.aws_secretsmanager_secret_version.db_secret_version.secret_string
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.prod_subnet_group.id
}
