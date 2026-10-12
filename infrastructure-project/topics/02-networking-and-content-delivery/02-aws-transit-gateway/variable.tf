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

variable "tgw_name" {
  description = "Transit Gateway Name"
  type = string
  default = "Pras-Journey-Transit-Gateway"
}

variable "description" {
  type = string
  description = "Description for Transit Gateway"
  default = "Transit Gateway Central Hub for Muolti-VPC Architecture"
}

variable "amazon_sid_asn" {
  type = number
  description = "ASN Private Number for BGP or VPN"
  default = 64512
}

variable "auto_accept_shared_attachments" {
  type        = string
  description = "Automatic Accept Option Attachment from anohter Account (enable / disable)"
  default     = "disable"
}

variable "default_route_table_association" {
  type        = string
  description = "Opsi asosiasi otomatis ke default route table (enable / disable)"
  default     = "enable"
}

variable "default_route_table_propagation" {
  type        = string
  description = "Opsi propagasi otomatis ke default route table (enable / disable)"
  default     = "enable"
}

variable "dns_support" {
  type        = string
  description = "Opsi dukungan DNS di dalam Transit Gateway (enable / disable)"
  default     = "enable"
}

variable "vpn_ecmp_support" {
  type        = string
  description = "Opsi Equal Cost Multi-Path untuk VPN (enable / disable)"
  default     = "enable"
}

variable "multicast_support" {
  type        = string
  description = "Opsi dukungan komunikasi multicast (enable / disable)"
  default     = "disable"
}

variable "security_group_referencing_support" {
  type = string
  description = "For automation SG to VPC each Other"
  default = "disable"
}

variable "vpc_attachments" {
  type = map(object({
    vpc_id = string
    subnet_ids = list(string) 
  }))
  description = "List VPC can be attach to transit gateway"
}

variable "tags" {
  type        = map(string)
  description = "Tag tambahan opsional untuk resource TGW"
  default     = {}
}
