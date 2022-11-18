provider "aws" {
  region  = "af-south-1"
  profile = "terraform-role"
}

resource "aws_codecommit_repository" "test" {
  repository_name = var.repository_name
  description     = var.repository_description
  tags            = var.codecommit_tags
}

// Creating triggers for now, CodeStar not available on Cape Town Region
resource "aws_sns_topic" "test" {
  name              = var.topic_name
  kms_master_key_id = "alias/aws/sns"
  tags              = var.topic_tags
}

// Todo: Fix the permissions to SNS topic
resource "aws_codecommit_trigger" "test" {
  repository_name = aws_codecommit_repository.test.repository_name

  trigger {
    name            = var.trigger_name
    events          = ["updateReference"]
    branches        = ["main"]
    destination_arn = aws_sns_topic.test.arn
  }
}

// Codebuild - Work in progresss 
resource "aws_iam_role" "build_role" {
  name = "CodeBuildRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "build_policy" {
  role = aws_iam_role.build_role.name
  name = "CodeBuildPolicy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ],
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_codebuild_project" "test-build-project" {
  name          = "TestProject"
  description   = "The project to build a NodeJS web application"
  build_timeout = "5"
  service_role  = aws_iam_role.build_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group-codebuild"
      stream_name = "web-page-build"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "my-webpage"
  }

  source_version = "main"

  tags = {
    Environment = "Test"
  }
}

# Testing driving S3 bucket features 
# This to be moved later 
resource "aws_s3_bucket" "log_bucket" {
  bucket = "draznet-log-bucket-18-nov-2022"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "draznet-insecure-tf-bucket-18-nov-2022"
  acl    = "private"
  
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_logging" "draznet-insecure-tf-bucket-18-nov-2022" {
  bucket = aws_s3_bucket.bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_logging" "bucket_logging" {
  bucket = aws_s3_bucket.bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}