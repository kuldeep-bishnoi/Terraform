variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to create"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "Amazon Machine Image (AMI) ID"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = "my-iam-role"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0123456789abcdefg"
}

variable "tags" {
  description = "Tags to apply to the EC2 instances"
  type        = map(string)
  default     = {
    Name = "EC2-Instance"
  }
}
