# saintcon23/advanced_terraform/intro_to_modules/providers
terraform {
  backend "s3" {
    bucket = "terraform-stored-state"
    key    = "global/s3/saintcon23_server/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-stored-state"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  required_version = ">= 1.6.1"
}

provider "aws" {
  region = var.region
}
