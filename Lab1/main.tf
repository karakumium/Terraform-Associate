provider "aws" {

    region = "us-west-1"  
}

resource "aws_instance" "my-Ubuntu-web" {
  ami           = "ami-0d382e80be7ffdae5"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform Ubuntu"
    Owner = "Sergey"
    Project= "Fenix"
  }
}

resource "aws_instance" "my-AMI-AWS" {
  ami    = "ami-04b6c97b14c54de18"
  instance_type = "t3.micro"

  tags = {
    Name = "Amazon Linux"
    Owner = "Sergey"
  }
}
