provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}
resource "aws_db_instance" "lab9-prod" {
  identifier           = "lab9-prod-mysql-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = "administrator"
  password             = data.aws_ssm_parameter.rds_password.value
}
//generate password
resource "random_password" "lab9-db-pass" {
  length           = 24
  special          = true
  override_special = "#!()-_"
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/lab9-prod-mysql-rds/password"
  description = "master password for RDS"
  type        = "SecureString"
  value       = random_password.lab9-db-pass.result
}

//retrieve password

data "aws_ssm_parameter" "rds_password" {
  name       = "/prod/lab9-prod-mysql-rds/password"
  depends_on = [aws_ssm_parameter.rds_password]
}

//outputs

output "lab9-rds_address" {
  value = aws_db_instance.lab9-prod.address
}

output "lab9-rds_port" {
  value = aws_db_instance.lab9-prod.port
}

output "lab9-rds_endpoint" {
  value = aws_db_instance.lab9-prod.endpoint
}
output "lab9-rds_username" {
  value = aws_db_instance.lab9-prod.username
}
output "lab9-rds_password" {
  value = nonsensitive(data.aws_ssm_parameter.rds_password.value)

  // sensitive = true
}
