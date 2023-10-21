# Saintcon 23 - Cloud Automation

## Locals Overview

### What is a local variable?
Local variables are used to simplify the configuration.  It provides an easy way to apply the same value to multiple resources.  In our example we will repeat the same tags to multiple resources.  This will allow us to change the tags in one place and have it apply to all resources.

## Locals Instructions

In this example below we have created a locals variable group called ```common_tags```.  Here we have set the ```Name``` tag to be populated with the local.name variable that we set above.  In this case it will be populated with dev-amazon2023.  

We have also set the ```Service``` tag to be populated with the ```local.service_name``` variable.  In this case it will be populated with ```example```.  We have also set the ```Environment``` tag to be populated with the ```local.environment``` variable.  In this case it will be populated with ```dev```.  We have also set the ```Terraform``` tag to be populated with the ```local.terraform_code``` variable.  In this case it will be populated with ```moderate_data```.

Modify ```/moderate_terraform/locals/main.tf``` to include the following code.  
```
locals {
  name           = "amazon2023"
  service_name   = "example"
  environment    = "dev"
  terraform_code = "moderate_data"
}
```

```
locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Name        = local.name
    Service     = local.service_name
    Environment = local.environment
    Terraform   = local.terraform_code
  }
```
Create a generic ```local``` for the Network Tags.

```
  network_tags = merge(local.common_tags, {
    department = "devsecops"
    owner      = "dev.at.saintcon.org"
  })
```
### 
Create a more specific ```local``` for the network tags.
```
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
```
## Add locals to AWS resources
```

```
# Next Step: Variables
```/saintcon32/moderate_terraform/variables/README.md```

# Appendix A: The Completed Code -- Spoiler Alert

## Providers.tf
```
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
```
## Locals.tf
```
#######################
## Create the Locals ##
#######################
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
```
## Data.tf
```
##################################
## Create the AMI Data Variable ##
##################################
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
output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}
```
## Main.tf
```
####################
## Create the VPC ##
####################
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags       = local.vpc_tags
}
#################################
## Create the Internet Gateway ##
#################################
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = local.network_tags
}
#######################
## Create the Subnet ##
#######################
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = local.network_tags
}
############################
## Create the Route Table ##
############################
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  tags = local.network_tags
}
##############################
## Create the Default Route ##
##############################
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.example.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example.id
}
##################################
## Create the Route Association ##
##################################
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}
#############################################
## Create the Security Group to allow SSH  ##
## Modify the cider_blocks to your home IP ##
#############################################
resource "aws_security_group" "example" {
  name_prefix = "dev-ssh-access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] ## Allow all outbound traffic
  }
  tags = local.security_tags

  vpc_id = aws_vpc.example.id
}

####################################
## Create the actual Ec2 Instance ##
####################################
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id 
  instance_type = "t2.micro"
  key_name      = "dev-example-key"
  subnet_id     = aws_subnet.example.id
  tags          = local.ec2_tags

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]
  user_data = <<EOF
#!/bin/bash
### Standard Patching
sudo dnf --assumeyes update
EOF
}
output "ec2_global_ips" {
  value = aws_instance.example.public_ip
}
```