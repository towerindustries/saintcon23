locals {
  name           = "dev-amazon2023"
  service_name   = "example"
  owner          = "utahsaint"
  environment    = "dev"
  terraform_code = "advanced_terraform_v2"
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

####################
## Create the VPC ##
####################
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr_block # This is the CIDR block of the VPC
  tags = {
    Name = "dev-vpc"
  }
}
#################################
## Create the Internet Gateway ##
#################################
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "dev-internet-gateway"
  }
}
#######################
## Create the Subnet ##
#######################
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.subnet_cidr_block # This is the CIDR block of the subnet
  availability_zone = var.availability_zone
  tags = {
    Name = "dev-subnet"
  }
}
############################
## Create the Route Table ##
############################
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-route-table"
  }
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
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
    cidr_blocks = var.sg_cidr_blocks_allow_ssh
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
    cidr_blocks = var.sg_cidr_blocks_allow_http
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    # cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
    cidr_blocks = var.sg_cidr_blocks_allow_https
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
####################################
## Create the actual Ec2 Instance ##
####################################
resource "aws_instance" "example" {
  ami                  = data.aws_ami.latest_amazon_linux_2.id
  instance_type        = var.instance_type        # This is the type of instance you want to create.
  iam_instance_profile = var.iam_instance_profile # This is the IAM role you want to use.
  key_name             = var.key_name             # This is the key you want to use to ssh into the instance.
  subnet_id            = aws_subnet.example.id
  tags                 = local.common_tags

  root_block_device {
    volume_size = var.volume_size # If you wanted to increase the hard drive space here it is.
    volume_type = var.volume_type # The type of storage you want to use.
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]
  user_data = file("./user_data.sh") # This is the user data script that will run when the instance is created.
}
