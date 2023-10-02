
######################
## Provider Details ##
######################
variable "availability_zone" {
  description = "The availability zone"
  type = string
  default = "us-east-1a"
}

################
## Networking ##
################
variable "vpc_id" {
  description = "The VPC ID"
  type = string
  default = ""
}
variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type = string
  default = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  type = string
  default = "10.0.1.0/24"
  
}
variable "route_table_id" {
  description = "The route table ID"
  type = string
  default = ""
}
variable "internet_gateway" {
 description = "The internet gateway ID"
 type = string
 default = "" 
}
variable "subnet_id" {
  description = "value of subnet id"
  type = string
  default = ""
}
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

##################
## EC2 Instance ##
##################
variable "ami_id" {
  description = "The AMI ID"
  type = string
  default = ""
}
variable "instance_type" {
  description = "The instance type"
  type = string
  default = "t2.micro"
}
variable "iam_instance_profile" {
  description = "The IAM instance profile"
  type = string
  default = "SSMInstanceProfile"
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
variable "vpc_security_group_ids" {
  description = "The VPC security group IDs"
  default = ""
}
  
variable "user_data" {
  description = "The user data"
  default = ""
}
