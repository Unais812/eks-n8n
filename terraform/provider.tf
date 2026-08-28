terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.62.0"
    }
  }

  backend "s3" {
    bucket = "n8n-eks-deployment-bucket"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}