variable "aws_region" {
  description = "region"
  type        = string
  default     = "ap-southeast-3"
}

# Environment
variable "environment" {
  description = "ENV Name (dev, stag, prod)"
  type        = string
  default     = "dev"
}

#Project Name
variable "project_name" {
  description = "Service Name"
  type        = string
  default     = "portofolio"
}