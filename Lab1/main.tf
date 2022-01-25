provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "terraform-study"
  region                  = "us-west-2"
}

resource "aws_instance" "LAB1-my-web" {
  ami           = "ami-0892d3c7ee96c0bf7"
  instance_type = "t3.micro"

  tags = {
    Name  = "Terraform Ubuntu"
    Owner = "Akhmed"
  }
}
