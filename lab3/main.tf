provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}



resource "aws_instance" "web" {
  ami                    = data.aws_ami.centos.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with PrvateIP: $MYIP</h2><b>Built by Terraform." > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "WebServer SG"
  description = "privet"
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
  tags = {
    Name = "lab2"
  }
}
