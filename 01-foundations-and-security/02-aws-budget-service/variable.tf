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

#Project Name
variable "project_name" {
  description = "Service Name"
  type        = string
  default     = "portofolio"
}

variable "budget_name" {
  type          = string
  description   = "Unique Name for Budget"
}

variable "budget_type" {
  type          = string
  description   = "Type : COST, USAGE, RI_UTILIZATION, RI_COVERAGE, SAVING_PLAN_COVERAGE"
  default       = "COST"

  validation {
    condition       = contains(["COST", "USAGE", "RI_UTILIZATION", "RI_COVERAGE", "SAVING_PLAN_COVERAGE"], var.budget_type)
    error_message   = "Choose one : COST, USAGE, RI_UTILIZATION, RI_COVERAGE, SAVING_PLAN_COVERAGE"
  }
}

variable "time_unit" {
  type = string
  description = "Period Budget : DAILY, MONTHLY, QUARTERLY, ANNUALY"
  default = "MONTHLY"

  validation {
    condition     = contains(["DAILY", "MONTHLY", "QUARTERLY", "ANNUALLY"], var.time_unit)
    error_message = "Choose one : DAILY, MONTHLY, QUARTERLY, ANNUALLY."
  }
}

variable "time_start" {
  type = string
  description = "Time Start Budget with format RFC3339"
  default = null
}

variable "time_end" {
  type = string
  description = "Time End Budget Monitoring"
  default = null
}

variable "budget_limit" {
  type = object({
    amount = string
    unit   = string 
  })
  description = "Maximum Amount of Money to Allocation and Currency "
}

variable "cost_filters" {
  type        = map(list(string))
  description = "(Optional) Map filter dimention cost AWS (example: Service, LinkedAccount, Region)."
  default     = {}
}

variable "cost_filter_tags" {
  type        = map(list(string))
  description = "(Optional) Map filter Based AWS Resource Tags."
  default     = {}
}

variable "include_credit" {
  type        = bool
  description = "(Optional) Include Credit on Calculation"
  default     = false
}

variable "include_discount" {
  type        = bool
  description = "(Optional) Include Discount on Calculation"
  default     = true
}

variable "include_other_subscription" {
  type = bool
  description = "AWS Subcription"
  default = true
}

variable "include_recurring" {
  type = bool
  description = "AWS Recurring"
  default = true
}

variable "include_refund" {
  type = bool
  description = "AWS Refund"
  default = true
}

variable "include_subscription" {
  type = bool
  description = "AWS Subcription"
  default = true
}

variable "include_support" {
  type = bool
  description = "AWS Support"
  default = true
}

variable "include_tax" {
  type = bool
  description = "AWS tax"
  default = true
}

variable "include_upfront" {
  type = bool
  description = "AWS upfront"
  default = true
}

variable "use_blended" {
  type = bool
  description = "AWS Blended"
  default = false
}

variable "use_amortized" {
  type = bool
  description = "AWS Amortized"
  default = false
}

variable "notifications" {
  type = list(object({
    comparison_operator        = string       # GREATER_THAN, LESS_THAN, EQUAL_TO
    threshold                  = number       # Value threshold (misal: 50, 80, 100)
    threshold_type             = string       # PERCENTAGE or ABSOLUTE_VALUE
    notification_type          = string       # ACTUAL or FORECASTED
    subscriber_email_addresses = list(string) # Email Objective
  }))
  description = "(Required) Daftar threshold alert dan email penerima."
  default     = []
}