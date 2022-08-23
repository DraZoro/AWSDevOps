terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27.0"
    }
  }

  required_version = ">= 1.2.7"
}

provider "aws" {
  region = "af-south-1"
  # Using for learning purpose 
  profile = "terraform-role"
  default_tags {
    tags = {
        Environment = "Test"
        Department = "Training"

    }
  }
}

resource "aws_codecommit_repository" "test" {
  repository_name = "my-webpage"
  description     = "A basic repository for testing purpose"
}