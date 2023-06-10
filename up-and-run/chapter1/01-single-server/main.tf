terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
    region = "ap-southeast-1"
}
resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
    owners = ["099720109477"]
}

resource "aws_instance" "example" {
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    user_data = <<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install busybox
        sudo apt install httpd
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p 8080 &
    EOF
    user_data_replace_on_change = true
    tags = {
        Name = "terraform-example"
    }
}

data "aws_vpc" "default" {
    default = true
}
output "public_ip" {
    value       = aws_instance.example.public_ip
    description = "The public IP of the Instance"
}