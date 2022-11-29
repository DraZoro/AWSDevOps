terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.41.0"
    }
  }

  #   required_version = ">= 1.3.5"
  #   backend "s3" {
  #     bucket = "draznet-infra"
  #     key    = "tf-states/k8s.tfstate"
  #     region = "af-south-1"
  #   }

}