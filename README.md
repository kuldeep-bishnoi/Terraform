# Infrastructure as Code with Terraform

This project demonstrates the use of Terraform for Infrastructure as Code (IaC). It includes configurations for AWS services such as S3 and EC2.

## What is Infrastructure as Code?

Infrastructure as Code (IaC) is the practice of managing and provisioning computing infrastructure through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.

## About Terraform

Terraform is an open-source IaC software tool created by HashiCorp. It enables users to define and provide data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

## Project Structure

- `aws-S3/`: Contains Terraform configuration for AWS S3 bucket creation and management.
- `aws-EC2/`: Contains Terraform configuration for AWS EC2 instance provisioning.

## Getting Started

1. Install Terraform
2. Configure AWS credentials
3. Navigate to the desired directory (`aws-S3` or `aws-EC2`)
4. Run `terraform init` to initialize the working directory
5. Run `terraform plan` to see the execution plan
6. Run `terraform apply` to apply the changes

## Note

Ensure to review and understand the configurations before applying them to your AWS account.
