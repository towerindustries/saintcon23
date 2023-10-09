# saintcon23/advanced_terraform/intro_to_modules/modules/networking/variables.tf
################
## Networking ##
################

variable "vpc_id" {
  description = "VPC-ID"
  type = string
  default = ""
}

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
