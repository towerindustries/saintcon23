########################
## Provider Variables ##
########################
variable "region" {
  description = "aws region"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "The availablity zone"
  type        = string
  default     = ""
}
