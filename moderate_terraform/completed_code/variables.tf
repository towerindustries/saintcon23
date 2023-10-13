######################
## Provider Details ##
######################
variable "region" {
  description = "AWS Region"
  type = string
  default = ""
}

variable "availability_zone" {
  description = "The availablity zone"
  type        = string
  default     = ""
}
################
## Networking ##
################
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = ""
}
variable "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
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
##################
## EC2 Instance ##
##################
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