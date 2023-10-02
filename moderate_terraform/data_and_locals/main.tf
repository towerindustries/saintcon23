locals {
  name              = "dev-amazon2023"
  service_name      = "example"
  owner             = "utahsaint"
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
}


resource "aws_instance" "example" {
  ami  = data.aws_ami.latest_amazon_linux_2.id 
  tags = local.common_tags
}
