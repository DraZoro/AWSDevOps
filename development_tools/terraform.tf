terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }

  required_version = ">= 1.3.5"
  backend "s3" {
    bucket = "draznet-infra"
    key    = "tf-states/codetools.tfstate"
    region = "af-south-1"
  }

}
