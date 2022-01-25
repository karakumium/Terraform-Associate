provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}

resource "aws_instance" "lab7-my_server_web" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.lab7-terraform_SG.id]
  tags                   = { Name = "Lab7 Web server" }
  depends_on             = [aws_instance.lab7-my_server_db, aws_instance.lab7-my_server_app]
}

resource "aws_instance" "lab7-my_server_app" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.lab7-terraform_SG.id]
  tags                   = { Name = "Lab7 App server" }
  depends_on             = [aws_instance.lab7-my_server_db]
}

resource "aws_instance" "lab7-my_server_db" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.lab7-terraform_SG.id]
  tags                   = { Name = "Lab7 DB server" }
}


resource "aws_security_group" "lab7-terraform_SG" {
  name        = "Lab7 SG"
  description = "Lab7"
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
  tags = { Name = "Lab7 SG" }
}
