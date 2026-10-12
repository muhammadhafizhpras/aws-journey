# Region
variable aws_region {
  type        = string
  default     = "ap-southeast-3"
  description = "region"
}

# Environment
variable "environment" {
    type        = string
    default     = "prod"
    description =  "ENV tag (dev, stag, prod)"

    validation {
    condition = contains (["dev","stag","prod"], var.environment)
    error_message = "Environtment : dev, stag, prod"
  }
}

# Name for this project
variable "project_name" {
  type        = string
  default     = "aws-project"
  description = "Project Name"
}

# Cost Center
variable "cost_center" {
  type = string
  default = "pras"
  description = "Cost Ceneter ID"
}

# Owner this project
variable "owner" {
  type = string
  default = "Clodu-Enginer"
  description = "Team or Person for this resource"
}

# S3 Bucket
variable "bucket_name" {
  type        = string
  default     = "ijagrjew9gjer0jgeriogjareogj0r"
  description = "Prefix Name for s3 must unique scale global"
}

# Versioning
variable "enable_versioning" {
  type        = bool
  default     = true
  description = "for enabled versioning"
}

# Force Destroy
variable "force_destroy" {
  type = bool
  default = false
  description = "Force destroy"
}

# Intelligent Class
variable "enable_intelligent_tiering" {
  type        = bool
  default     = true 
  description = "True for Enable dan False for DIsable"
}

# Intelligent Retention
variable "intelligent_tiering_days" {
  type        = number
  default     = 90
  description = "description"
}

# Access Tier 
variable "access_tier_it" {
  type        = string
  default     = "ARCHIVE_ACCESS"
  description = "Access tier"
}

# Standart Infrequent Access
variable "enable_standart_ia" {
  type        = bool
  default     = true
  description = "True for Enable dan False for DIsable"
}

# Infrenquent Access Retention
variable "standart_ia_days" {
  type        = number
  default     = 30
  description = "Days for transisi"
}

# Onezone Infrequent Access
variable "enable_onezone_ia" {
  type        = bool
  default     = true
  description = "True for Enable dan False for DIsable"
}

# One zone IA Retention
variable "onezone_ia_days" {
  type        = number
  default     = 60
  description = "Days for transition from onezone ia to glacier"
}

# Glacier Flexible Class
variable "enable_glacier_flexible" {
  type        = bool
  default     = true
  description = "True for Enable dan False for DIsable"
}

# Glacier Flexible Retention
variable "glacier_flexible_days" {
  type        = number
  default     = 90
  description = "Days for transition from onzone ia to glacier flexible"
}

# Glacier Deep Archive
variable "enable_glacier_deep_archive" {
  type        = bool
  default     = true
  description = "True for Enable and False for Disable"
}

# Glacier Deep Archive Retention
variable "glacier_deep_archive_days" {
  type        = number
  default     = 180
  description = "Days for trasition from glacier flexible to glacier deep archive"
}

# Object Lock
variable "enable_object_lock" {
  type        = bool
  default     = true
  description = "Enable Object Lock"
}

# Object Lock Mode (Compliance or Governance)
variable "object_lock_mode" {
  type        = string
  default     = "COMPLIANCE"
  description = "Mode (COMPLIANCE or GOVERNANCE)"

  validation {
    condition = contains(["COMPLIANCE", "GOVERNANCE"], var.object_lock_mode)
    error_message   = "COMPLIANCE or GOVERNANCE"
  }
}

# Object Lock Retention
variable "object_lock_days" {
  type        = number
  default     = 30
  description = "Duration retention object for lock"
}

# Object Ownership 
variable "object_ownership" {
  type = string
  default = "BucketOwnerEnforced"
  description = "Object Ownership "
}

# Bucket Tags
variable "bucket_tags" {
  type        = map(string)
  default     = {
    DataClassification = "Public"
    Compliance         = "PCI"
    Application        = "Portofolio Project"
  }
  description = "Tagging"
}

# Block Public Access for Access Control List 
variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Blocking create Public ACL"
}

# Block Public Access Permission 
variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Block Create Public Policy"
}

# Ignore Existing ACL
variable "ignore_public_acls" {
  type        = bool
  default     = true
  description = "Ignore Existing all Public ACL"
}

# Restrict Public Permission Bucket
variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Block Public Subnet access s3"
}

# Lifecycle Configuration Days
variable "lifecycle_expiration_days" {
  type = number
  default = 30
  description = "Days Before Noncurrent Versions and delete markers are Cleaned Up"
}

# Access Bassed Access Control
variable "enable_abac" {
  type = bool
  default = true
  description = "For Enable ABAC tagging permission access"
}

# Encryption
variable "enable_encryption" {
  type = bool
  default = true
  description = "Encryption for object on s3"
}