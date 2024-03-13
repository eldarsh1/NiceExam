terraform {
  backend "s3" {
    bucket         = "niceexam-eldar"
    key            = "terraform.tfstate"
    region         = "us-west-2"
  }
}


provider "aws" {
  region = "us-west-2"  
}

resource "aws_vpc" "my_vpc" {
  cidr_block          = "10.0.0.0/16"
  enable_dns_support  = true
  enable_dns_hostnames = true
  tags = {
    Name = "Eldar-test"
    env  = "dev"  # Add environment tag
    owner = "Eldar"  # Add owner tag
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "my_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Eldar-test"
    env  = "dev"  # Add environment tag
    owner = "Eldar"  # Add owner tag
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
  ingress {
    from_port   = 22  # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Eldar-test"
    env  = "dev"  # Add environment tag
    owner = "Eldar"  # Add owner tag
  }
}

resource "aws_instance" "my_instance" {
  ami             = "ami-07bff6261f14c3a45"
  instance_type   = "t2.micro"
  key_name        = "devops-eldare"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups  = [aws_security_group.my_sg.id]
  tags = {
    Name = "Eldar-test"
    env  = "dev"  # Add environment tag
  }
    provisioner "file" {
    source      = "./hello_world.html"
    destination = "/tmp/index.html"
    connection {
      type        = "ssh"
      user        = "ec2-user"  # Replace with the appropriate user for your AMI
      private_key = file("./devops-eldare.pem")  # Replace with the path to your private key
      host        = aws_instance.my_instance.public_ip  # Replace with your instance's public IP or DNS
    }
  }
    provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo mv /tmp/index.html /var/www/html/index.html",  # Move the uploaded file to the destination with proper permissions
      "sudo systemctl restart httpd"  # Restart Apache to apply changes
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./devops-eldare.pem")
      host        = aws_instance.my_instance.public_ip
    }
  }
}

