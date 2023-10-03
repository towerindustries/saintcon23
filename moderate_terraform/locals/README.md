# Saintcon 23 - Cloud Automation

## Locals Instruction

### What is a local variable?
A local variable is a variable that is defined in the Terraform configuration and is used to simplify the configuration.  It is not passed to the Terraform Cloud or Terraform Enterprise.

### Why use a local variable?
Local variables are used to simplify the configuration.  They are not passed to the Terraform Cloud or Terraform Enterprise.  They are used to simplify the configuration.

### How do I use a local variable?
Local variables are defined in the Terraform configuration.  They are used to simplify the configuration.  They are not passed to the Terraform Cloud or Terraform Enterprise.

# Create Basic Code
Modify ```/moderate_terraform/locals/main.tf``` with your desired tags

```
locals {
  name              = "dev-amazon2023"
  service_name      = "example"
  owner             = "utahsaint"
  environment       = "dev"
  terraform_code    = "advanced_terraform_v2"
}
```
In this example we have created a locals variable group called ```common_tags```.

```
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
```
Here we have set the "Name" tag to be populated with the local.name variable.  In this case it will be populated with dev-amazon2023.

```
  environment_tags = merge(local.common_tags, {
    Department = "DevSecOps"
  })
}
```
By adding the merge command it will now add "department = DevSecOps" to the common tags.
The results:
```
Environment	dev
Name	dev-amazon2023
Service	example
Department	DevSecOps
Terraform	advanced_terraform_v2
Owner	utahsaint
```

To add tags for another use such as VPC tags you would add the following:
```
  vpc_tags = {
    Department = "Network-Team"
  }
```
This will only add the "Department = Network-Team" tag to the VPC.

# Complete Code
```

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
  environment_tags = merge(local.common_tags, {
    Department = "DevSecOps"
  })
  vpc_tags = {
    Department = "Network-Team"
  }
}
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
}
#######################
## Create the Subnet ##
#######################
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
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
  tags = {
    Name = "dev-security-group"
  }

  vpc_id = aws_vpc.example.id
}

####################################
## Create the actual Ec2 Instance ##
####################################
resource "aws_instance" "example" {
  ami           = "ami-03a6eaae9938c858c" # Feed it the AMI you found
  instance_type = "t2.micro"              # Choose the size/type of compute you want
  key_name      = "dev-example-key"       # Here is the public key you want for ssh.
  subnet_id     = aws_subnet.example.id   # Put it on the Subnet you created.
  tags          = local.environment_tags
  #   tags = {
  #     Name = "dev-amazon2023"
  #   }  


  root_block_device {
    volume_size = 30    # If you wanted to increase the hard drive space here it is.
    volume_type = "gp3" # The type of storage you want to use.
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.example.id # Add the security group you created.
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