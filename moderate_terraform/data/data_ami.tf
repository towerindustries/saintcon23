###########################################################
## /saintcon23/moderate_terraform/data_and_locals/data_ami.tf ##
###########################################################
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
output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}
