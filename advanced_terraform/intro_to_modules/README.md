# Saintcon 23
## Cloud Automation -- Intro to Modules

# Module Overview


# Providers.tf
No changes needed it should like this.  
```/working_directory/providers.tf```
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
    }
  }
  required_version = ">= 1.5.7"
}

provider "aws" {
  # Configuration options
  region = var.region
}

```
# Variables.tf
```/working_directory/variables.tf```
```
########################
## Provider Variables ##
########################
variable "region" {
  description = "aws region"
  type = string
  default = "us-east-1"
}

variable "availability_zone" {
  description = "The availablity zone"
  type        = string
  default     = "us-east-1a"
}
```

# EC2 Modules Directory Creation
This is where we will store the module files.  
```/working_directory/modules```
* Create the directory ```/working_directory/modules/ec2```
* Create the file ```/working_directory/modules/ec2/main.tf```
* Create the file ```/working_directory/modules/ec2/variables.tf```
* Create the file ```/working_directory/modules/ec2/outputs.tf```

# EC2 Module
### Main.tf
 
```/working_directory/modules/ec2/main.tf```

```
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.example.id
  tags          = local.ec2_tags

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]
  user_data = file("nginxserver_amazon_deploy.sh")
}
```
### EC2 Module -- variables.tf
```/working_directory/modules/ec2/variables.tf```

```
###################
## EC2 Variables ##
###################
variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = ""
}
variable "key_name" {
  description = "The key name"
  type        = string
  default     = ""
}
variable "volume_size" {
  description = "The volume size"
  type        = string
  default     = ""
}
variable "volume_type" {
  description = "The volume type"
  default     = ""
}
```

### EC2 Module -- outputs.tf
```/working_directory/modules/ec2/outputs.tf```

```
#################
## EC2 Outputs ##
#################
output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}
output "ec2_global_ips" {
  value = aws_instance.example.public_ip
}
```

# Security Groups Module
## Security Groups Module Directory Creation
This is where we will store the module files.  
```/working_directory/modules```
* Create the directory ```/working_directory/modules/security_groups```
* Create the file ```/working_directory/modules/security_groups/main.tf```
* Create the file ```/working_directory/modules/security_groups/variables.tf```
* Create the file ```/working_directory/modules/security_groups/outputs.tf```
  
### Security Groups Module -- Main.tf
```/working_directory/modules/security_groups/main.tf```

```
resource "aws_security_group" "example" {
  name_prefix = "dev-ssh-access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks_allow_ssh
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks_allow_http
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sg_cidr_blocks_allow_https
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.security_tags

  vpc_id = aws_vpc.example.id
}
```

### Security Groups Module -- variables.tf
```/working_directory/modules/security_groups/variables.tf```

```
variable "sg_cidr_blocks_allow_ssh" {
  description = "The CIDR blocks of the security group"
  type        = list(string)
  default     = [""]
}
variable "sg_cidr_blocks_allow_http" {
  description = "The CIDR blocks of the security group"
  type        = list(string)
  default     = [""]
}
variable "sg_cidr_blocks_allow_https" {
  description = "The CIDR blocks of the security group"
  type        = list(string)
  default     = [""]
}
```

### Security Groups Module -- outputs.tf
```/working_directory/modules/security_groups/outputs.tf```

```
DON'T REALLY HAVE ANY
```
# Networking Module

## Networking Module Directory Creation
This is where we will store the module files.  
```/working_directory/modules```
* Create the directory ```/working_directory/modules/networking```
* Create the file ```/working_directory/modules/networking/main.tf```
* Create the file ```/working_directory/modules/networking/variables.tf```
* Create the file ```/working_directory/modules/networking/outputs.tf```

### Networking Module -- main.tf
```/working_directory/modules/networking/main.tf```

```
####################
## Create the VPC ##
####################
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr_block
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
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags              = local.network_tags
}
############################
## Create the Route Table ##
############################
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
  tags   = local.network_tags
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
```

### Networking Module -- variables.tf
```
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = ""
}
variable "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  type        = string
  default     = ""
}
```

### Networking Module -- outputs.tf
```
DON'T REALLY HAVE ANY
```
# Root Directory Files

## Root Directory Creation
This is where we will store the root files.  
```/working_directory/```
* Create the file ```/working_directory/main.tf```
* Create the file ```/working_directory/variables.tf```
* Create the file ```/working_directory/outputs.tf```
* Create the file ```/working_directory/data.tf```
  
### Root Directory -- main.tf
```/working_directory/main.tf```

Define where the modules will be located at:
```
module "security_group" {
  source = "./modules/security_groups/"
  #  version = "1.0.0"
}
module "ec2_instance" {
  source = "./modules/ec2/"
  #  version = "1.0.0"
}
module "networking" {
  source = "./modules/networking/"
  #  version = "1.0.0"
}
```

### Root Directory -- variables.tf
```/working_directory/variables.tf```

```
variable "region" {
  description = "AWS Region"
  type = string
  default = ""
}

variable "availability_zone" {
  description = "The availablity zone"
  type        = string
  default     = ""
}
```
### Root Directory -- outputs.tf
```/working_directory/outputs.tf```

```

```

### Root Directory -- data.tf
```/working_directory/data.tf```  
Add in the lookup for the AMI and the Locals configuration.

```
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
    Environment = local.environment
    Terraform   = local.terraform_code
  }
  environment_tags = merge(local.common_tags, {
    department = "devsecops"
    owner             = "dev.at.saintcon.org"
  })
  network_tags = merge(local.common_tags, {
    department = "network-team"
    owner             = "noc.at.saintcon.org"
  })
}

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
```

### Root Directory -- terraform.tfvars
```/working_directory/terraform.tfvars```

```
region = "us-east-1"
availability_zone = "us-east-1a"
```

# Appendix A: Random Things to discuss
* ignore_changes
* data.tf -- data sources
* locals.tf -- local variables
* terraform.tfvars -- variables

