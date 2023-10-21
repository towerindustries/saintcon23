# saintcon23/advanced_terraform/intro_to_modules/modules/security_groups/variables.tf
variable "vpc_id" {
  description = "The vpc id"
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
variable "security_tags" {
  description = "security group tags"
  type        = map(string)
  default     = {}
}
