# saintcon23/advanced_terraform/intro_to_modules/modules/ec2/variables.tf
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