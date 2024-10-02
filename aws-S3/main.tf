# install aws provider
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.54.1"
        }
        random = {
            source = "hashicorp/random"  # random is used to generate random values
            version = "3.6.2"
        }
    }
}

# configure the aws provider
provider "aws" {
    region = "us-east-1"
}

# generate a random string
resource "random_string" "random" {
    length = 8
    special = true
    override_special = "/@£$"
}

# create a bucket
resource "aws_s3_bucket" "myBucket" {
    bucket = "my-tf-test-bucket-${random_string.random.result}"
}

# output the bucket name
output "bucket_name" {
    value = aws_s3_bucket.myBucket.bucket
}

# upload a file to the bucket
resource "aws_s3_object" "myFile" {
    bucket = aws_s3_bucket.myBucket.bucket
    key    = "myFile.txt"
    source = "myFile.txt"
}

# output the file name after upload
output "file_name" {
    value = aws_s3_object.myFile.key
}

# create bucket policy to allow public read access
resource "aws_s3_bucket_policy" "myBucketPolicy" {
    bucket = aws_s3_bucket.myBucket.bucket
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid       = "PublicReadGetObject"
                Effect    = "Allow"
                Principal = "*"
                Action    = "s3:GetObject"
                Resource  = "arn:aws:s3:::${aws_s3_bucket.myBucket.bucket}/*"
            }
        ]
    })
}

# create a bucket policy to allow specific domains to access the bucket
resource "aws_s3_bucket_policy" "myBucketPolicySpecificDomains" {
    bucket = aws_s3_bucket.myBucket.bucket
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid       = "PublicReadGetObject"
                Effect    = "Allow"
                Principal = "*"
                Action    = "s3:GetObject"
                Resource  = "arn:aws:s3:::${aws_s3_bucket.myBucket.bucket}/*"
                Condition = {
                    StringEquals = {
                        "aws:Referer" = ["http://www.example.com", "http://www.example.com/blog"]
                    }
                }
            }
        ]
    })
}

# output the bucket policy
output "bucket_policy_specific_domains" {
    value = aws_s3_bucket_policy.myBucketPolicySpecificDomains.policy
}

# create a bucket policy to allow specific ip addresses to access the bucket
resource "aws_s3_bucket_policy" "new_bucket_policy" {
    bucket = aws_s3_bucket.myBucket.bucket
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid       = "PublicReadGetObject"
                Effect    = "Allow"
                Principal = "*"
                Action    = "s3:GetObject"
                Resource  = "arn:aws:s3:::${aws_s3_bucket.myBucket.bucket}/*"
                Condition = {
                    IpAddress = {
                        "aws:SourceIp" = ["192.168.1.1/32", "192.168.1.2/32"]
                    }
                }
            }
        ]
    })
}

# output the bucket policy
output "new_bucket_policy" {
    value = aws_s3_bucket_policy.new_bucket_policy.policy
}
