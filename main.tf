# main.tf

# Configure AWS provider
provider "aws" {
  region = "us-east-1"  # Specify your preferred AWS region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create a subnet within the VPC
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Create security group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic to web servers"

  ingress {
    from_port   = 80
    to_port     = 80
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

# Create EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Specify your preferred AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }
}

