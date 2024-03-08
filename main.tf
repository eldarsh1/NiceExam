provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Change to your desired availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "my_subnet"
  }
}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my_sg"
  }
}

resource "aws_instance" "my_instance" {
  ami             = "ami-xxxxxxxxxxxxxxxx"
  instance_type   = "t2.micro"
  key_name        = "your-key-pair"
  subnet_id       = aws_subnet.my_subnet.id
  security_group  = [aws_security_group.my_sg.id]
  tags = {
    Name = "my_instance"
  }

  provisioner "file" {
    source      = "path/to/hello_world.html"
    destination = "/var/www/html/index.html"
  }
}
