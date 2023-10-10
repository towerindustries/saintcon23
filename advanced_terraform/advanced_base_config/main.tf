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
  tags = local.network_tags
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
  tags = local.environment_tags
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
  tags = local.common_tags

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