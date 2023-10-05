locals {
  name              = "dev-amazon2023"
  service_name      = "example"
  environment       = "dev"
  terraform_code    = "advanced_terraform_v2"
}
locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Name        = local.name
    Service     = local.service_name
    Owner       = local.owner
    Environment = local.environment
    Terraform   = local.terraform_code
  }
  environment_tags = merge(local.common_tags, {
    department = "devsecops"
    owner             = "dev.at.saintcon.org"
  })
  network_tags = {
    department = "network-team"
    owner             = "noc.at.saintcon.org"
  }
}
#################################
## Add to respective resources ##
#################################
resource "aws_vpc" "example" {
  tags = local.network_tags
}
resource "aws_instance" "example" {
  tags = local.common_tags
}
resource "aws_subnet" "example" {
  tags = local.environment_tags
}