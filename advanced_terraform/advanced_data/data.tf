# saintcon23/advanced_terraform/advanced_data/main.tf
data "aws_ami" "latest_amazon_linux_2023" {
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-minimal-2023*"]
  }
  filter {
    name = "owner-id"
    values = ["137112412989"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }  
  filter {
    name = "owner-alias"
    values = ["amazon"]  
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

variable "vpc_id" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_subnet" "example" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = var.availability_zone
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
}