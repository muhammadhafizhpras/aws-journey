#Region
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

# Minimum Password Length
variable "minimum_password_length" {
  description = "Minimum Length Password"
  type        = number
  default     = 14
}

# Maximum Password Age
variable "max_password_age" {
  description = "Maximum Age of Password in days"
  type        = number
  default     = 90
}

# Lowercase Password Required
variable "require_lowercase_characters" {
  description = "Lowercase Characters Required"
  type        = bool
  default     = true
}

# Uppercase Password Required
variable "require_uppercase_characters" {
  description = "Uppercase Characters Required"
  type        = bool
  default     = true
}

# Number Required
variable "require_numbers" {
  description = "Number Required"
  type        = bool
  default     = true
}

# Symbols Required
variable "require_symbols" {
  description = "Symbols Required"
  type        = bool
  default     = true
}

# User Can Change Password
variable "allow_user_to_change_password" {
  description = "User can change password or not"
  type        = bool
  default     = true
}

# Password Reuse Prevention
variable "password_reuse_prevention" {
  description = "Number of previous passwords to prevent reuse (1-24)"
  type        = number
  default     = 5
}

#Password Mode for user
variable "password_mode" {
  description = "Password = generated or custom"
  type        = string
  default     = "generated"

  validation {
    condition     = contains(["generated","custom"], var.password_mode)
    error_message = "Choose = generated or custom"
  }
}

#Custom Password for user
variable "custom_password" {
  description = "Password Custom Mode Must >= 8 Characters"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.custom_password == null || length(var.custom_password) >= 8
    error_message = "Custom password must 8 characters"
  }
}

###---------------------- IAM Idendity -------------------------###
# IAM Group
variable "group_name" {
  description = "Group Name"
  type        = string
  default     = "Group Name?"
}

# IAM User
variable "user_name" {
  description = "User Name for User"
  type        = string
  default     = "User Name?"
}

# IAM Role
variable "ec2_role_name" {
  description = "IAM Role Name for EC2 on AWS"
  type        = string
  default     = "EC2-S3-Readonly-Role"
}