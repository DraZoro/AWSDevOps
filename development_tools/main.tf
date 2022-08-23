provider "aws" {
  region = "af-south-1"
  # Using for learning purpose 
  profile = "terraform-role"
}

resource "aws_codecommit_repository" "test" {
  repository_name = var.repository_name
  description     = var.repository_description
  tags            = var.codecommit_tags
}