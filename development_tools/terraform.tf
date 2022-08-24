terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27.0"
    }
  }

  //Todo: Introduce remote state
  # required_version = ">= 1.2.7"
  # backend "s3" {
  #   bucket = "draznet-infra"
  #   key    = "tf-states/codetools.tfstate"
  #   region = "af-south-1"
  # }

}
