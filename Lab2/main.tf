provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}

resource "aws_instance" "lab2-web" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = <<EOF
  #!/bin/bash
  echo Hi
  yum update 
  yum install httpd -y
  MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  echo "<h2>Web  Fuck with IP:$MYIP</h2><br>Buid by Terraform" > /var/www/html/index.html
  systemctl status apache2
  systemctl enable apache2.service
  systemctl status httpd
  systemctl enable httpd.service
  EOF
  tags = {
    Name  = "LAB2 Terraform web server"
    Owner = "Zukhra"
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
