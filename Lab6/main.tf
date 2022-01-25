provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}


resource "aws_instance" "lab6-web" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = file("userdata.sh")
  tags = {
    Name  = "LAB6 Terraform web server"
    Owner = "Serg"
  }
  lifecycle {
    create_before_destroy = true
  }

}



resource "aws_eip" "lb" {
  instance = aws_instance.lab6-web.id
  vpc      = true
  tags = {
    Name  = "LAB6 Terraform web server"
    Owner = "Serg"
  }
}

resource "aws_security_group" "web" {
  name        = "Lab6 Web server SG"
  description = "Lab6"
  dynamic "ingress" {
    for_each = ["80", "443"]
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
}
