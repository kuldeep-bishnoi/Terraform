# Remote State Configuration for AWS EC2 Instance
#
# This Terraform configuration demonstrates the use of remote state storage in AWS S3.
# It sets up an EC2 instance and stores the Terraform state file in a specified S3 bucket.
#
# Key components:
# 1. AWS provider configuration
# 2. S3 backend for remote state storage
# 3. EC2 instance resource
# 4. Output values for instance ID and public IP
#
# Note: Ensure that the S3 bucket specified in the backend configuration exists
# and that you have the necessary permissions to access it.

# configure the backend
terraform {
    required_providers {
         aws = {
            source = "hashicorp/aws"
            version = "5.54.1"
        }
    }
    backend "s3" {
        bucket = "my-tf-test-bucket-1234567890" # bucket name
        key = "terraform.tfstate" # state file name
        region = "ap-south-1" # region
    }
}

# create a resource
resource "aws_instance" "myInstance" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
}

# output the instance id
output "instance_id" {
    value = aws_instance.myInstance.id
}

# output the instance public ip
output "instance_public_ip" {
    value = aws_instance.myInstance.public_ip
}
