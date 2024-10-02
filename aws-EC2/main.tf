# install aws provider
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.54.1"
        }
    }
}

# set the aws region
provider "aws" {
    region = var.aws_region
}

# create a new EC2 instance
resource "aws_instance" "myserver" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
}

# output the instance id
output "instance_id" {
    value = aws_instance.myserver.id
}

# output the instance public ip
output "instance_public_ip" {
    value = aws_instance.myserver.public_ip
}

# destroy the instance after 10 minutes
resource "null_resource" "destroy_instance" {
    provisioner "local-exec" {
        command = "sleep 600 && terraform destroy -target aws_instance.myserver"
    }
}

# Create multiple EC2 instances
variable "instance_count" {
    default = 3
}

resource "aws_instance" "multi_servers" {
    count         = var.instance_count
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    tags = {
        Name = "Server-${count.index + 1}"
    }
}

# Output the IDs of all created instances
output "multi_instance_ids" {
    value = aws_instance.multi_servers[*].id
}

# Create an EC2 instance with a larger instance type
resource "aws_instance" "upgraded_server" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.small"
    tags = {
        Name = "Upgraded-Server"
    }
}

# Create an EC2 instance with a smaller instance type
resource "aws_instance" "downgraded_server" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.nano"
    tags = {
        Name = "Downgraded-Server"
    }
}

# Create an EC2 instance with user data for initialization
resource "aws_instance" "server_with_userdata" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    user_data     = <<-EOF
                    #!/bin/bash
                    echo "Hello, World!" > index.html
                    nohup python -m SimpleHTTPServer 80 &
                    EOF
    tags = {
        Name = "Server-With-UserData"
    }
}

# Create a security group
resource "aws_security_group" "allow_http" {
    name        = "allow_http"
    description = "Allow HTTP inbound traffic"

    ingress {
        description = "HTTP from VPC"
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

    tags = {
        Name = "allow_http"
    }
}

# Create an EC2 instance with the security group
resource "aws_instance" "server_with_sg" {
    ami             = "ami-0c55b159cbfafe1f0"
    instance_type   = "t2.micro"
    security_groups = [aws_security_group.allow_http.name]
    tags = {
        Name = "Server-With-SG"
    }
}

# Lifecycle rule to prevent destruction of a critical instance
resource "aws_instance" "critical_server" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    tags = {
        Name = "Critical-Server"
    }

    lifecycle {
        prevent_destroy = true
    }
}

# Output to demonstrate data source usage
data "aws_availability_zones" "available" {
    state = "available"
}

# Output the availability zones
output "availability_zones" {
    value = data.aws_availability_zones.available.names
}

# Create an EC2 instance with a specific availability zone
resource "aws_instance" "specific_az_server" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    tags = {
        Name = "Specific-AZ-Server"
    }
}

# output the instance id
output "specific_az_instance_id" {
    value = aws_instance.specific_az_server.id
}

# Create an EC2 instance with a specific subnet
resource "aws_instance" "specific_subnet_server" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    subnet_id     = "subnet-0123456789abcdefg"
    tags = {
        Name = "Specific-Subnet-Server"
    }
}

# output the instance id
output "specific_subnet_instance_id" {
    value = aws_instance.specific_subnet_server.id
}

# Create an EC2 instance with a specific VPC subnet
resource "aws_instance" "specific_vpc_server" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    subnet_id     = "subnet-0123456789abcdefg" # Replace with your actual subnet ID
    tags = {
        Name = "Specific-VPC-Server"
    }
}

# Output the instance ID
output "specific_vpc_instance_id" {
    value = aws_instance.specific_vpc_server.id
}

# Create an EC2 instance with a specific IAM role
resource "aws_instance" "iam_role_server" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    iam_instance_profile = "my-iam-role"
    tags = {
        Name = "IAM-Role-Server"
    }
}

# output the instance id
output "iam_role_instance_id" {
    value = aws_instance.iam_role_server.id
}
