# AWS Networking Concepts and Components

# 1. AWS Provider
# The AWS provider is used to interact with AWS resources.
# It's configured with a specific version to ensure compatibility.
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.54.1"
        }
    }
}

# The provider is configured with a specific region.
# This determines where the AWS resources will be created.
provider "aws" {
    region = "ap-south-1"
}

# 2. Virtual Private Cloud (VPC)
# A VPC is a logically isolated section of the AWS cloud where you can launch AWS resources.
# It provides control over your networking environment, including IP address ranges,
# subnets, route tables, and network gateways.
resource "aws_vpc" "myVPC" {
    cidr_block = "10.0.0.0/16"  # Defines the IP address range for the VPC
    tags = {
        Name = "myVPC"
    }
}

# 3. Subnets
# Subnets are segments of a VPC's IP address range where you can place groups of isolated resources.

# 3.1 Public Subnet
# A public subnet is a subnet that's associated with a route table that has a route to an Internet Gateway.
# This allows resources in the subnet to access the internet and be accessible from the internet.
resource "aws_subnet" "myPublicSubnet" {
    vpc_id = aws_vpc.myVPC.id  # Associates the subnet with our VPC
    cidr_block = "10.0.1.0/16"  # Defines the IP address range for this subnet
    tags = {
        Name = "myPublicSubnet"
    }
}

# 3.2 Private Subnet
# A private subnet is a subnet that's not associated with a route table that has a route to an Internet Gateway.
# Resources in a private subnet cannot directly access the internet and are not directly accessible from the internet.
resource "aws_subnet" "myPrivateSubnet" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = "10.0.2.0/16"
    tags = {
        Name = "myPrivateSubnet"
    }
}

# 4. Internet Gateway
# An Internet Gateway is a horizontally scaled, redundant, and highly available VPC component
# that allows communication between instances in your VPC and the internet.
resource "aws_internet_gateway" "myInternetGateway" {
    vpc_id = aws_vpc.myVPC.id  # Attaches the Internet Gateway to our VPC
    tags = {
        Name = "myInternetGateway"
    }
}

# 5. Route Table
# A route table contains a set of rules, called routes, that are used to determine
# where network traffic is directed.
resource "aws_route_table" "myRouteTable" {
    vpc_id = aws_vpc.myVPC.id
    route {
        cidr_block = "0.0.0.0/0"  # This route sends all IPv4 traffic to the Internet Gateway
        gateway_id = aws_internet_gateway.myInternetGateway.id
    }
    tags = {
        Name = "myRouteTable"
    }
}

# 6. Route Table Association
# Associates a subnet with a route table. This determines the routing for the subnet.
# In this case, we're associating our public subnet with the route table that has
# a route to the Internet Gateway, making it a truly "public" subnet.
resource "aws_route_table_association" "myRouteTableAssociation" {
    subnet_id = aws_subnet.myPublicSubnet.id
    route_table_id = aws_route_table.myRouteTable.id
}

# Note: This configuration creates a basic VPC setup with public and private subnets.
# For a complete network architecture, you might also want to consider:
# - NAT Gateways: Allow instances in private subnets to access the internet
# - Network ACLs: Act as a firewall for controlling traffic in and out of subnets
# - Security Groups: Act as a firewall for controlling traffic in and out of instances
# - VPN or Direct Connect: For secure communication between your on-premises network and VPC
