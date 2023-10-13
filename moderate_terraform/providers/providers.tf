terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  required_version = ">= 1.6.1"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}