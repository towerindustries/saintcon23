# saintcon23/advanced_terraform/intro_to_modules/modules/networking/variables.tf
###################
## VPC Variables ##
###################
variable "vpc_tags" {
  description = "vpc tags"
  type        = map(string)
  default     = {}
}
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = ""
}
######################
## Subnet Variables ##
######################

variable "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  type        = string
  default     = ""
}
variable "availability_zone" {
  description = "The availability zone"
  type        = string
  default     = ""
}
variable "network_tags" {
  description = "network tags"
  type        = map(string)
  default     = {}
}
