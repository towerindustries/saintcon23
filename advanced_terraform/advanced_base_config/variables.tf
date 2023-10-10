######################
## Provider Details ##
######################
variable "region" {
  description = "AWS Region"
  type = string
  default = "us-east-1"
}

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