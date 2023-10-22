# saintcon23/advanced_terraform/intro_to_modules/modules/ec2/main.tf

#######################
## Search for an AMI ##
#######################
data "aws_ami" "latest_amazon_linux_2023" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-minimal-2023*"]
  }
  filter {
    name   = "owner-id"
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
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
#######################
## Create the Locals ##
#######################
locals {
  name           = "amazon2023"
  service_name   = "example"
  environment    = "dev"
  terraform_code = "advanced_terraform_intro_to_modules"
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
############################################
## Dumps the AMI info out into a variable ##
############################################
output "latest_amazon_linux_2_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2.id
}
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  tags          = var.ec2_tags

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = var.security_group_id
  user_data = file("nginxserver_amazon_deploy.sh")
}
