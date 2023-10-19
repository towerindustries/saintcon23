# Saintcon 23
## Cloud Automation -- Intro to Modules

# Module Overview
We will be making our own reusable modules.  

# Providers.tf
No changes needed it should like this.
```/working_directory/providers.tf```
```
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

```
# Variables.tf
```/working_directory/variables.tf```  
These variables will be completed in the terraform.tfvars file.
```
########################
## Provider Variables ##
########################
variable "region" {
  description = "aws region"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "The availablity zone"
  type        = string
  default     = ""
}
```
# Copy ```nginxserver_amazon_deploy.sh``` to working_directory
```/working_directory/nginxserver_amazon_deploy.sh```  

# EC2 Module
##  EC2 Module Directory Creation
This is where we will store the module files.  
```/working_directory/modules```
* Create the directory ```/working_directory/modules/ec2```
* Create the file ```/working_directory/modules/ec2/main.tf```
* Create the file ```/working_directory/modules/ec2/variables.tf```
* Create the file ```/working_directory/modules/ec2/outputs.tf```


### Main.tf
 
```/working_directory/modules/ec2/main.tf```

```
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

```
### EC2 Module -- variables.tf
```/working_directory/modules/ec2/variables.tf```

```
###################
## EC2 Variables ##
###################
variable "ami" {
  description = "AMI ID"
  type        = string
  default     = ""
}
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
variable "security_group_id" {
  description = "security group id"
  type        = list(string)
  default     = [""]
}
variable "ec2_tags" {
  description = "The tags on the ec2 instance"
  type        = map(string)
  default     = {}
}
variable "subnet_id" {
  description = "The subnet id"
  type        = string
  default     = ""
}
```

### EC2 Module -- outputs.tf
```/working_directory/modules/ec2/outputs.tf```

```
#################
## EC2 Outputs ##
#################
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
  name_prefix = "dev-access"

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
  tags = var.security_tags

  vpc_id = var.vpc_id
}
```

### Security Groups Module -- variables.tf
```/working_directory/modules/security_groups/variables.tf```

```
variable "vpc_id" {
  description = "The vpc id"
  type        = string
  default     = ""
}
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
variable "security_tags" {
  description = "security group tags"
  type        = map(string)
  default     = {}
}
```

### Security Groups Module -- outputs.tf
```/working_directory/modules/security_groups/outputs.tf```

```
output "security_group_id" {
  value = aws_security_group.example.id
}
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
  tags       = var.vpc_tags
}
#################################
## Create the Internet Gateway ##
#################################
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = var.network_tags
}
#######################
## Create the Subnet ##
#######################
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags              = var.network_tags
}
############################
## Create the Route Table ##
############################
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
  tags   = var.network_tags
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
###################
## VPC Variables ##
###################
variable "vpc_tags" {
  description = "vpc tags"
  type        = map(string)
  default     = {}
}
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = ""
}
######################
## Subnet Variables ##
######################

variable "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  type        = string
  default     = ""
}
variable "availability_zone" {
  description = "The availability zone"
  type        = string
  default     = ""
}
variable "network_tags" {
  description = "network tags"
  type        = map(string)
  default     = {}
}
```

### Networking Module -- outputs.tf
```
output "vpc_id" {
  value = aws_vpc.example.id
}
output "subnet_id" {
  value = aws_subnet.example.id
}
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
module "ami_amazon2023" {
  source = "./modules/ami-amazon2023/"
  #  version = "1.0.0"
}
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
########################
## Provider Variables ##
########################
variable "region" {
  description = "aws region"
  type        = string
  default     = ""
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
NOTHING HERE YET
```

### Root Directory -- data.tf
```/working_directory/data.tf```  
Add in the lookup for the AMI and the Locals configuration.

```
locals {
  name           = "amazon2023"
  service_name   = "example"
  environment    = "dev"
  terraform_code = "intro_to_modules"
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

### Root Directory -- terraform.tfvars
```/working_directory/terraform.tfvars```

```
region = "us-east-1"
availability_zone = "us-east-1a"
```

# Appendix A: The Completed Code -- Spoiler Alert
```main.tf```

```
module "ami_amazon2023" {
  source = "./modules/ami-amazon2023/"
  #  version = "1.0.0"
}

module "networking" {
  source = "./modules/networking/"
  #  version = "1.0.0"
  vpc_cidr_block    = "10.255.0.0/16"
  subnet_cidr_block = "10.255.1.0/24"
  network_tags      = local.network_tags
  vpc_tags          = local.vpc_tags
}
module "security_groups" {
  source = "./modules/security_groups/"
  #  version = "1.0.0"
  vpc_id                     = module.networking.vpc_id
  sg_cidr_blocks_allow_http  = ["161.28.24.210/32"]
  sg_cidr_blocks_allow_https = ["161.28.24.210/32"]
  sg_cidr_blocks_allow_ssh   = ["161.28.24.210/32"]
  security_tags              = local.security_tags
}
module "ec2" {
  source = "./modules/ec2/"
  #  version = "1.0.0"
  instance_type          = "t2.micro"
  ami                    = module.ami_amazon2023.latest_amazon_linux_2023_ami_id
  key_name               = "dev-example-key"
  volume_size            = "30"
  volume_type            = "gp3"
  ec2_tags               = local.ec2_tags
  subnet_id              = module.networking.subnet_id
  security_group_id      = [module.security_groups.security_group_id]
}
```

```/variables.tf```  
```/outputs.tf```  
```/data.tf```  
```/terraform.tfvars```

```/modules/ami-amazon2023/main.tf```  
```/modules/ami-amazon2023/variables.tf```  
```/modules/ami-amazon2023/outputs.tf```




```/modules/ec2/main.tf```  
```/modules/ec2/variables.tf```  
```/modules/ec2/outputs.tf```  

```/modules/networking/main.tf```  
```/modules/networking/variables.tf```  
```/modules/networking/outputs.tf```  

```modules/security_groups/main.tf```  
```modules/security_groups/variables.tf```  
```modules/security_groups/outputs.tf```  



```nginxserver_amazon_deploy.sh```



