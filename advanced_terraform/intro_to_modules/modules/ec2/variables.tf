# saintcon23/advanced_terraform/intro_to_modules/modules/ec2/variables.tf
###################
## EC2 Variables ##
###################
variable "ami" {
  description = "AMI ID"
  type        = string
  default     = ""
}
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

variable "volume_delete_on_termination" {
  description = "The volume delete on termination"
  type = bool
  default = true
}

variable "security_group_id" {
  description = "security group id"
  type        = list(string)
  default     = [""]
}
variable "ec2_tags" {
  description = "The tags on the ec2 instance"
  type        = map(string)
  default     = {}
}
variable "subnet_id" {
  description = "The subnet id"
  type        = string
  default     = ""
}