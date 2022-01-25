provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}

resource "aws_instance" "lab8-my_server_web" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.lab8-terraform_SG.id]
  tags                   = { Name = "lab8 Web server" }
  depends_on             = [aws_instance.lab8-my_server_db, aws_instance.lab8-my_server_app]
}

resource "aws_instance" "lab8-my_server_app" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.lab8-terraform_SG.id]
  tags                   = { Name = "lab8 App server" }
  depends_on             = [aws_instance.lab8-my_server_db]
}

resource "aws_instance" "lab8-my_server_db" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.lab8-terraform_SG.id]
  tags                   = { Name = "lab8 DB server" }
}


resource "aws_security_group" "lab8-terraform_SG" {
  name        = "lab8 SG"
  description = "lab8"
  dynamic "ingress" {
    for_each = ["80", "443", "22", "3389"]
    content {
      description = "Allow many ports"
      from_port   = ingress.value
      to_port     = ingress.value
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
  tags = { Name = "lab8 SG" }
}


# ---------------------------------------
output "lab8-my_sg_id" {
  value       = aws_security_group.lab8-terraform_SG.id
  description = "Lab8 My Security Group ID for all servers"
}

//
//output "lab8-my_sg_all_details" {
//  value       = aws_security_group.lab8-terraform_SG
//  description = "Lab8 All details about My Security Group"
//}

output "lab8-web_private_ip" {
  value       = aws_instance.lab8-my_server_web.private_ip
  description = "Lab8 Web Server Private IP"
}

output "lab8-app_private_ip" {
  value       = aws_instance.lab8-my_server_app.private_ip
  description = "Lab8 App Server Private IP"
}

output "lab8-db_private_ip" {
  value       = aws_instance.lab8-my_server_db.private_ip
  description = "Lab8 DB Server Private IP"
}

output "lab8-listof_private_ips" {
  value       = [aws_instance.lab8-my_server_web.private_ip, aws_instance.lab8-my_server_db.private_ip, aws_instance.lab8-my_server_app.private_ip]
  description = "Lab8 List of private Ips for the  servers"
}
