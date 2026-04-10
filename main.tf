provider "aws" {
  region = "ap-south-1"
}

# #creating ec2 instance
resource "aws_instance" "my_first_server" {
  ami           = "ami-05d2d839d4f73aafb"  # Example AMI (update!)
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-First-Server"
  }
}

#create vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

#create subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}

#create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

#create security group
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# put ec2 inside vpc
resource "aws_instance" "dev_server" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Dev-Server"
  }
}