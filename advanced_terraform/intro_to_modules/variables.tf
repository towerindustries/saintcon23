# /intro_to_modules/variables.tf

######################
## Provider Details ##
######################
variable "region" {
  description = "aws region"
  type = string
  default = ""
}

variable "availability_zone" {
  description = "The availablity zone"
  type        = string
  default     = ""
}
################

