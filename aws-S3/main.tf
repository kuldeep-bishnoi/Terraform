# install aws provider
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.54.1"
        }
    }
}

# configure the aws provider
provider "aws" {
    region = "us-east-1"
}

# create a bucket
resource "aws_s3_bucket" "myBucket" {
    bucket = "my-tf-test-bucket"
}

# output the bucket name
output "bucket_name" {
    value = aws_s3_bucket.myBucket.bucket
}

# upload a file to the bucket
resource "aws_s3_bucket_object" "myFile" {
    bucket = aws_s3_bucket.myBucket.bucket
    key = "./myFile.txt"
    source = "myFile.txt"
}

# output the file name after upload
output "file_name" {
    value = aws_s3_bucket_object.myFile.key
}

# create bucket policy to allow public read access
# resource "aws_s3_bucket_policy" "myBucketPolicy" {
#     bucket = aws_s3_bucket.myBucket.bucket
#     policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "PublicReadGetObject",
#             "Effect": "Allow",
#             "Principal": "*",
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::my-tf-test-bucket/*"
#         }
#     ]
# }
# POLICY
# }


# create a bucket poilicy to allow specific domains to access the bucket
# resource "aws_s3_bucket_policy" "myBucketPolicy" {
#     bucket = aws_s3_bucket.myBucket.bucket
#     policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "PublicReadGetObject",
#             "Effect": "Allow",
#             "Principal": "*",
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::my-tf-test-bucket/*",
#             "Condition": {
#                 "StringEquals": {
#                     "aws:Referer": "http://www.example.com, http://www.example.com/blog"
#                 }
#             }
#         }
#     ]
# }
# POLICY
# }

# # output the bucket policy
# output "bucket_policy" {
#     value = aws_s3_bucket_policy.myBucketPolicy.policy
# }

# create a bucket policy to allow specific ip addresses to access the bucket
resource "aws_s3_bucket_policy" "myBucketPolicy" {
    bucket = aws_s3_bucket.myBucket.bucket
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-tf-test-bucket/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": "192.168.1.1/32, 192.168.1.2/32"
                }
            }
        }
    ]
}
POLICY
}

# output the bucket policy
output "bucket_policy" {
    value = aws_s3_bucket_policy.myBucketPolicy.policy
}
