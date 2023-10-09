# saintcon23/advanced_terraform/intro_to_modules/modules/security_groups/variables.tf


#####################
## Security Groups ##
#####################
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