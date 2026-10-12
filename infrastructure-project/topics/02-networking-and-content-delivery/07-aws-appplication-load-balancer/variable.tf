variable "aws_region" {
  type = string
  description = "Choose Region"
  default = "ap-southeas-3"
}

variable "environment" {
  type = string
  description = "environment : /dev/stag/prodcution"
}

variable "alb_name" {
  type = string
  description = "Application Load Balacing"
  default = "ALB Name"
}