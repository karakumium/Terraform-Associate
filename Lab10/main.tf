provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}
resource "aws_db_instance" "lab10-prod" {
  identifier           = "lab10-prod-mysql-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = "administrator"
  password             = aws_secretsmanager_secret_version.lab10-rds_password.secret_string
}
//generate password
resource "random_password" "lab10-db-pass" {
  length           = 24
  special          = true
  override_special = "#!()-_"
}

// store password in the   
resource "aws_secretsmanager_secret" "lab10-rds_password" {
  name                    = "/prod/lab10-prod-mysql-rds/password"
  description             = "LAB10 master password for RDS"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "lab10-rds_password" {
  secret_id     = aws_secretsmanager_secret.lab10-rds_password.id
  secret_string = random_password.lab10-db-pass.result
}

//retrieve password
data "aws_secretsmanager_secret_version" "lab10-rds_password" {
  secret_id  = aws_secretsmanager_secret.lab10-rds_password.id
  depends_on = [aws_secretsmanager_secret_version.lab10-rds_password]
}

//outputs

output "lab10-rds_address" {
  value = aws_db_instance.lab10-prod.address
}

output "lab10-rds_port" {
  value = aws_db_instance.lab10-prod.port
}

output "lab10-rds_endpoint" {
  value = aws_db_instance.lab10-prod.endpoint
}
output "lab10-rds_username" {
  value = aws_db_instance.lab10-prod.username
}
//output "lab10-rds_password" {
// value = nonsensitive(data.aws_secretsmanager_secret_version.lab10-rds_password)

// sensitive = true
//}
