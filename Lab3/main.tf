provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}


resource "aws_instance" "lab3-web" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = file("userdata.sh")
  tags = {
    Name  = "Terraform web server"
    Owner = "Serg"
  }
}

resource "aws_security_group" "web" {
  name        = "Web server SG"
  description = "dfdfd"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
