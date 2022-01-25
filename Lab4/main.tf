provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}


resource "aws_instance" "lab4-web" {
  ami                    = "ami-066333d9c572b0680" #Amazon linux 2
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = templatefile("userdata.sh.tpl", {
    f_name = "Khalif"
    l_name = "CC"
    names  = ["John", "Egor", "Denis", "Bitch", "Jopa"]
  })
  tags = {
    Name  = "Lab-4 Terraform web server"
    Owner = "Iguana"
  }
}

resource "aws_security_group" "web" {
  name        = "Web server SG"
  description = "This is a web server"
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
