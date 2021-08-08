provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "web" {
  ami                    = "ami-02f84cf47c23f1769" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = <<EOF
  #!/bin/bash
  yum update 
  yum install httpd -y
  MYIP=`curl http://169.254.169.254/lastest/meta-data/local-ipv4`
  echo "<h2>Web Fuck with IP:$MYIP</h2><br>Buid by Terraform" > /var/www/html/index.html
  service httpd start
  chkconfig httpd on
  EOF
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
