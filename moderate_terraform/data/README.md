# Saintcon 23 - Cloud Automation
## Data Overview 
The terraform data command is used to pull external information into your code.  This is useful for finding things like the latest AMI or a VPC ID.  It is also used if you have multiple resources that need the same information, you can use the data command to pull that information into your code.  This is a key piece of keeping your code DRY (Don't Repeat Yourself).

## Data Instructions

Copy this filter and output into your ```/working_directory/main.tf```. This will find the latest Amazon Linux 2023 AMI.  You can use this as a starting point for your own filters.

```
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

```


## Add the output command into ```main.tf```.
We will move the output command to an ```outputs.tf``` file later on.
```
output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}
```
## Change the ```aws_instance``` AMI statement with the new data command
```
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id 
}
```


# Next Steps:  Locals
```/saintcon32/moderate_terraform/locals/README.md```

# Appendix A: The Completed Code -- Spoiler Alert
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  required_version = ">= 1.5.7"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
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
############################################
## Dumps the AMI info out into a variable ##
############################################
output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}
####################
## Create the VPC ##
####################
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
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
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
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
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your current ip
  }
    ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your current ip
  }
    ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your current ip
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
  ami           = data.aws_ami.latest_amazon_linux_2023.id 
  instance_type = "t2.micro"
  key_name      = "dev-example-key"
  subnet_id     = aws_subnet.example.id
  tags = {
    Name = "dev-amazon2023"
  }  
  
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
output "ec2_global_ips" {
  value = aws_instance.example.public_ip
}

```
# Appendix B: Terraform Filtering Options
```
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
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "hypervisor"
    values = ["xen"]
  }
  filter {
    name   = "image-type"
    values = ["machine"]
  }
  filter {
    name   = "ena-support"
    values = ["true"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp3"]
  }
  filter {
    name   = "block-device-mapping.delete-on-termination"
    values = ["true"]
  }
  filter {
    name   = "block-device-mapping.device-name"
    values = ["/dev/xvda"]
  }
  filter {
    name   = "block-device-mapping.encrypted"
    values = ["false"]
  }
}
```
# Appendix C: How to find an AMI with the AWS CLI
### CLI Search for AMI

Search for a specific AMI with image-ids.  
* The region command speeds it up.


```
aws ec2 describe-images \
    --region us-east-1 \
    --image-ids ami-054aaceda83e053ee
    --owners amazon
```
Owner is short for ```OwnerId``` and is the Amazon account that owns the AMI.  In this case it is Amazon.
```
aws ec2 describe-images \
    --region us-east-1 \
    --owners amazon \
    --owner 247102896272
```
```
aws ec2 describe-images \
    --region us-east-1 \
    --owners amazon \
    --owner 247102896272 \
    --filters "Name=name,Values=al2023-ami-2023.*"
```
```
aws ec2 describe-images \
    --region us-east-1 \
    --owners amazon \
    --filters "Name=name,Values=al2023-ami-2023.*x86_64"
```
Search for an AMI owned by amazon with filters.

```
aws ec2 describe-images \
    --region us-east-1 \
    --owners amazon \
    --filters "Name=root-device-type,Values=ebs" "Name=virtualization-type,Values=hvm"
```
Searching for the Windows Platform.  Linux does not have a corrilating value.
```
aws ec2 describe-images \
    --region us-east-1 \
    --filters "Name=root-device-type,Values=ebs" "Name=platform,Values=windows"
```

Notice there is a Platform category here but not on the Amazon Image.  It only works for windows.

```
aws ec2 describe-images \
    --region us-east-1 \
    --filters "Name=root-device-type,Values=ebs" "Name=platform,Values=windows" "Name=name,Values=al2023-ami-2023"
```
The Image that Terraform picks with our filters.
```
aws ec2 describe-images \
    --region us-east-1 \
    --image-ids ami-0779b302ed007c203
```
```
aws ec2 describe-images \
    --region us-east-1 \
    --owners amazon \
    --owner 247102896272
```
# Appendix D: Valid Image Filters

* architecture - The image architecture (i386 | x86_64 | arm64 | x86_64_mac | arm64_mac ).
* block-device-mapping.delete-on-termination - A Boolean value that indicates whether the Amazon EBS volume is deleted on instance termination.
* block-device-mapping.device-name - The device name specified in the block device mapping (for example, /dev/sdh or xvdh ).
* block-device-mapping.snapshot-id - The ID of the snapshot used for the Amazon EBS volume.
* block-device-mapping.volume-size - The volume size of the Amazon EBS volume, in GiB.
* block-device-mapping.volume-type - The volume type of the Amazon EBS volume (io1 | io2 | gp2 | gp3 | sc1 | st1 | standard ).
* block-device-mapping.encrypted - A Boolean that indicates whether the Amazon EBS volume is encrypted.
* creation-date - The time when the image was created, in the ISO 8601 format in the UTC time zone (YYYY-MM-DDThh:mm:ss.sssZ), for example, 2021-09-29T11:04:43.305Z . You can use a wildcard (* ), for example, 2021-09-29T* , which matches an entire day.
* description - The description of the image (provided during image creation).
* ena-support - A Boolean that indicates whether enhanced networking with ENA is enabled.
* hypervisor - The hypervisor type (ovm | xen ).
* image-id - The ID of the image.
* image-type - The image type (machine | kernel | ramdisk ).
* is-public - A Boolean that indicates whether the image is public.
* kernel-id - The kernel ID.
* manifest-location - The location of the image manifest.
* name - The name of the AMI (provided during image creation).
* owner-alias - The owner alias (amazon | aws-marketplace ). The valid aliases are defined in an Amazon-maintained list. This is not the Amazon Web Services account alias that can be set using the IAM console. We recommend that you use the Owner request parameter instead of this filter.
* owner-id - The Amazon Web Services account ID of the owner. We recommend that you use the Owner request parameter instead of this filter.
* platform - The platform. The only supported value is windows .
* product-code - The product code.
* product-code.type - The type of the product code (marketplace ).
* ramdisk-id - The RAM disk ID.
* root-device-name - The device name of the root device volume (for example, /dev/sda1 ).
* root-device-type - The type of the root device volume (ebs | instance-store ).
* state - The state of the image (available | pending | failed ).
* state-reason-code - The reason code for the state change.
* state-reason-message - The message for the state change.
* sriov-net-support - A value of simple indicates that enhanced networking with the Intel 82599 VF interface is enabled.
* tag :<key> - The key/value combination of a tag assigned to the resource. Use the tag key in the filter name and the tag value as the filter value. For example, to find all resources that have a tag with the key Owner and the value TeamA , specify tag:Owner for the filter name and TeamA for the filter value.
* tag-key - The key of a tag assigned to the resource. Use this filter to find all resources assigned a tag with a specific key, regardless of the tag value.
* virtualization-type - The virtualization type (paravirtual | hvm ).
