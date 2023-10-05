# Saintcon 23 - Cloud Automation

## Variables Instructions

### Caution
You must disable terraform.tfvars or modify variables.tf for this code to work.  

### What is a variable?
A variable is a value that is defined in the Terraform configuration and is passed to the Terraform Cloud or Terraform Enterprise.

### Why use a variable?
Variables are used to simplify the configuration.  They are passed to the Terraform Cloud or Terraform Enterprise.  They are used to simplify the configuration.

### How do I use a variable?
Variables are defined in the Terraform configuration.  They are passed to the Terraform Cloud or Terraform Enterprise.

# Create ```variables.tf```
Create ```/moderate_terraform/variables/variables.tf```.  
This is where you will define your variables.

```
######################
## Provider Details ##
######################
variable "region" {
  description = "region"
  type = string
  default = "us-east"
}
variable "availability_zone" {
  description = "The availablity zone
  default     = "us-east-1a"
}
```

```
################
## Networking ##
################
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type = string
  default = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  type = string
  default = "10.0.1.0/24"
}
```
```
#####################
## Security Groups ##
#####################
variable "sg_cidr_blocks_allow_ssh" {
  description = "The CIDR blocks of the security group"
  type = list(string)
  default = ["104.28.252.4/32"]
}
variable "sg_cidr_blocks_allow_http" {
  description = "The CIDR blocks of the security group"
  type = list(string)
  default = ["104.28.252.4/32"]  
}
variable "sg_cidr_blocks_allow_https" {
  description = "The CIDR blocks of the security group"
  type = list(string)
  default = ["104.28.252.4/32"]  
}
```

```
##################
## EC2 Instance ##
##################
variable "instance_type" {
  description = "The instance type"
  type = string
  default = "t2.micro"
}
variable "key_name" {
  description = "The key name"
  type = string
  default = "dev-example-key"
}
variable "volume_size" {
  description = "The volume size"
  type = string
  default = "30"
}
variable "volume_type" {
  description = "The volume type"
  default = "gp3"
}
```
# Modify ```provider.tf```

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  required_version = "~> 1.5.7"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
```
Provider with Variables
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  required_version = "~> 1.5.7"
}

provider "aws" {
  # Configuration options
  region = var.region
}
```


# Modify ```main.tf```

## VPC
```
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = locals.vpc_tags
}
```
### VPC with Variables

```
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr_block
  tags = locals.vpc_tags
}
```
## Subnet
```
resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = local.common_tags
}
```
### Subnet with Variables
```
resource "aws_subnet" "example" {
  vpc_id     = var.vpc_cidr_block
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = local.common_tags
}
```
## Security Groups
```
resource "aws_security_group" "example" {
  name_prefix = "dev-ssh-access"
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
    ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
    ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] ## Allow all outbound traffic
  }
  tags = {
    Name = "dev-security-group"
  }
  
  vpc_id = aws_vpc.example.id
}
```
### Security Groups with Variables
```
resource "aws_security_group" "example" {
  name_prefix = "dev-ssh-access"
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = var.sg_cidr_blocks_allow_ssh
  }
    ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = var.sg_cidr_blocks_allow_http
  }
    ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = var.sg_cidr_blocks_allow_https
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] ## Allow all outbound traffic
  }
  tags = local.common_tags
  
  vpc_id = aws_vpc.example.id
}
```

## EC2
```
resource "aws_instance" "example" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"
  key_name      = "dev-example-key"
  subnet_id     = aws_subnet.example.id
  tags          = local.environment_tags
  
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]
  user_data = file("nginxserver_amazon_deploy.sh")
}
```
### EC2 with Variables
```
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id 
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.example.id  
  tags          = local.environment_tags
  
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
# The Completed Code -- Spoiler Alert

## ```providers.tf```
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  required_version = "~> 1.5.7"
}

provider "aws" {
  # Configuration options
  region = var.region
}
```
## ```variables.tf```
```
######################
## Provider Details ##
######################

variable "availability_zone" {
  description = "The availablity zone"
  type        = string
  default     = "us-east-1a"
}
################
## Networking ##
################
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "sg_cidr_blocks_allow_ssh" {
  description = "The CIDR blocks of the security group"
  type        = list(string)
  default     = ["161.28.24.210/32"]
}
variable "sg_cidr_blocks_allow_http" {
  description = "The CIDR blocks of the security group"
  type        = list(string)
  default     = ["161.28.24.210/32"]
}
variable "sg_cidr_blocks_allow_https" {
  description = "The CIDR blocks of the security group"
  type        = list(string)
  default     = ["161.28.24.210/32"]
}
##################
## EC2 Instance ##
##################
variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.micro"
}
variable "key_name" {
  description = "The key name"
  type        = string
  default     = "dev-example-key"
}
variable "volume_size" {
  description = "The volume size"
  type        = string
  default     = "30"
}
variable "volume_type" {
  description = "The volume type"
  default     = "gp3"
}
```

# ```main.tf```
```
locals {
  name           = "dev-amazon2023"
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
  environment_tags = merge(local.common_tags, {
    department = "devsecops"
    owner      = "dev.at.saintcon.org"
  })
  network_tags = merge(local.common_tags, {
    department = "network-team"
    owner      = "noc.at.saintcon.org"
  })
}
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
####################
## Create the VPC ##
####################
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr_block
  tags       = local.network_tags
}
#################################
## Create the Internet Gateway ##
#################################
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}
#######################
## Create the Subnet ##
#######################
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags              = local.environment_tags
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
  tags = local.common_tags

  vpc_id = aws_vpc.example.id
}

####################################
## Create the actual Ec2 Instance ##
####################################
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.example.id
  tags          = local.common_tags

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
