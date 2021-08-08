provider "aws" {

    region = "us-west-1"  
}

resource "aws_instance" "my-web" {
  ami           = "ami-0d382e80be7ffdae5"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform Ubuntu"
    Owner = "Sergey"
  }
}

