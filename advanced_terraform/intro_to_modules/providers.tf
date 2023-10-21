# saintcon23/advanced_terraform/intro_to_modules/providers
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  required_version = ">= 1.5.7"
}

provider "aws" {
  # Configuration options
  region = var.region
}
