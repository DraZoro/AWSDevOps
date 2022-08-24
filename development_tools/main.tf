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