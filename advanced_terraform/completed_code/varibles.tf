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