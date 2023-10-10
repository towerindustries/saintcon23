```saintcon23/advanced_terraform/advanced_data/README.md```
# Advanced Data
## Deploy the base infrastructure
```/advanced_terraform/base_config/```

This will deploy the following:
* VPC
* Subnet
* Route Table
* Internet Gateway
* Route Table Association
* Security Group
* Key Pair
* EC2 Instance
  


# Advanced Data Configuration

## New File Creation and Replication of Existing Files
1: Create a new directory called ```working_directory```  
2: Copy ```providers.tf``` from ```/advanced_terraform/base_config/``` to your ```working_directory```  
3: Create a new file named ```main.tf``` in your ```working_directory```  
4: Create a new file named ```variables.tf``` in your ```working_directory```  
5: Create a new file named ```terraform.tfvars``` in your ```working_directory```  
6: Create a new file named ```outputs.tf``` in your ```working_directory```


## Create a new ```main.tf``` file in your ```working_directory```

We will reuse the AMI filter from the previous section.  Copy the following code into your ```main.tf``` file.
```
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
### Copy the Data Output for AMI lookup and the Public IP into ```outputs.tf``` file.
```
output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}

output "ec2_global_ips" {
  value = aws_instance.example.public_ip
}
```
Copy the following code into your ```main.tf``` file.  
* Notice we added a ```second_server``` tag to our previous locals block.
* Add any tags you would like.

```
locals {
  name           = "dev-amazon2023"
  service_name   = "example"
  environment    = "dev"
  terraform_code = "advanced_terraform"
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
  second_server = merge(local.common_tags, {
    department = "testing"
    owner      = "dev.at.saintcon.org"
    Name       = "second_server"
  })
}
```
# Pull Existing Configuration from AWS

## Getting the VPC
We will need the vpc information to deploy our servers into an already existing one.
* This looks for a VPC with the tag ```Name = dev-terraform```
* Outputs the info to ```data.aws_vpc.current_vpc```
```
data "aws_vpc" "current_vpc" {
  tags = {
    Name = "dev-terraform"
  }
}
```
Copy the following code into your ```outputs.tf``` file.  

```
output "current_vpc_id" {
  value = data.aws_vpc.current_vpc.id
}
```

## Getting the Subnet
We will need the subnet information to deploy our servers into an already existing one.
* We need to know the VPC ID to get the subnet information.  We got this above.
* This looks for a Subnet with the tag ```Name = dev-terraform```
```
data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["dev-terraform"]
  }
}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)

  id = each.value
}
```
Copy the following code into your ```outputs.tf``` file.  
```
output "subnet_ids" {
  value = data.aws_subnets.example.ids
}

output "subnet_cidr_blocks" {
  value = [for subnet in data.aws_subnet.example : subnet.cidr_block]
}
```
## Security Group
We are adding the VPC-ID from above and searching for a security group with the tag ```Name = dev-terraform```
```
data "aws_security_group" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["dev-terraform"]
  }
}
```
Copy the following code into your ```outputs.tf``` file.  
```
output "security_group_id" {
  value = data.aws_security_group.example.id
}

output "security_group_name" {
  value = data.aws_security_group.example.name
}
```

## EC2 Instance
We combine all the outputs for the subnet, VPC, and security group to deploy our EC2 instance.  
* The element function will retrieve the first element of a list of AWS subnet IDs returned by the ```data.aws_subnets.example.ids``` data source. The retrieved subnet ID is then assigned to the subnet_id variable.
* The ```data.aws_security_group.example.id``` did not return more than one result so it did not need any additional functions.
  

```
resource "aws_instance" "example_2" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = element(tolist(data.aws_subnets.example.ids), 0)
  tags          = local.second_server

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_group.example.id]

  user_data = file("nginxserver_amazon_deploy.sh")
}
```
# Combine code together
```~/working_directory/main.tf```

```
locals {
  name           = "dev-amazon2023"
  service_name   = "example"
  environment    = "dev"
  terraform_code = "advanced_terraform"
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
  second_server = merge(local.common_tags, {
    department = "testing"
    owner      = "dev.at.saintcon.org"
    Name       = "second_server"
  })
}
data "aws_vpc" "current_vpc" {
  tags = {
    Name = "dev-terraform"
  }
}

output "current_vpc_id" {
  value = data.aws_vpc.current_vpc.id
}
data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["dev-terraform"]
  }
}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)

  id = each.value
}

output "subnet_ids" {
  value = data.aws_subnets.example.ids
}

output "subnet_cidr_blocks" {
  value = [for subnet in data.aws_subnet.example : subnet.cidr_block]
}
data "aws_security_group" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["dev-terraform"]
  }
}
output "security_group_id" {
  value = data.aws_security_group.example.id
}

output "security_group_name" {
  value = data.aws_security_group.example.name
}
resource "aws_instance" "example_2" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = element(tolist(data.aws_subnets.example.ids), 0)
  tags          = local.second_server

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_group.example.id]

  user_data = file("nginxserver_amazon_deploy.sh")
}
```
## Outputs.tf
```
output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}

output "ec2_global_ips" {
  value = aws_instance.example_garbage.public_ip
}
output "current_vpc_id" {
  value = data.aws_vpc.current_vpc.id
}
output "subnet_ids" {
  value = data.aws_subnets.example.ids
}
output "subnet_cidr_blocks" {
  value = [for subnet in data.aws_subnet.example : subnet.cidr_block]
}
```