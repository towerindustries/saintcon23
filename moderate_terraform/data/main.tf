#######################
## Search for an AMI ##
#######################
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
##########################################
## Add the Data AMI to the Ec2 Instance ##
##########################################
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id 
}
