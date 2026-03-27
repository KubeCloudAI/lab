# Generate a random 16-character password with special characters for database authentication
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!%^_-#&*()+="
}

# Create an AWS Secrets Manager secret to store the database password securely
resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "prod-db-password"
  recovery_window_in_days = 0
}

# Store the generated password in the AWS Secrets Manager secret
resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = random_password.db_password.result
}
