# /intro_to_modules/variables.tf
######################
## Provider Details ##
######################
variable "region" {
  description = "aws region"
  type = string
  default = "us-east-1"
}

variable "availability_zone" {
  description = "The availablity zone"
  type        = string
  default     = "us-east-1a"
}

