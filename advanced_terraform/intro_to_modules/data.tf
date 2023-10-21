locals {
  name           = "amazon2023"
  service_name   = "example"
  environment    = "dev"
  terraform_code = "advanced_terraform_v2"
}
locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Name        = local.name
    Service     = local.service_name
    Environment = local.environment
    Terraform   = local.terraform_code
  }
  network_tags = merge(local.common_tags, {
    department = "devsecops"
    owner      = "dev.at.saintcon.org"
  })
  security_tags = merge(local.common_tags, {
    department = "network-team"
    owner      = "noc.at.saintcon.org"
    Name       = "${local.environment}-${local.name}-sg"
  })
  vpc_tags = merge(local.common_tags, {
    department = "network-team"
    owner      = "noc.at.saintcon.org"
    Name       = "${local.environment}-${local.name}-vpc"
  })
  ec2_tags = merge(local.common_tags, {
    department = "network-team"
    owner      = "noc.at.saintcon.org"
    Name       = "${local.environment}-${local.name}-ec2"
  })
}