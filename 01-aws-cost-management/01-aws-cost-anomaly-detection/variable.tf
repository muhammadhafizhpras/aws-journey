variable "aws_region" {
  type = string
  description = "region"
  default = "ap-southeast-3"
}

variable "environment" {
  type = string
  description = "env"
  default = "prod"
}

variable "project_name" {
  type = string
  description = "name of project"
  default = "portofolio"
}

variable "monitor_name" {
  type          = string
  description   = "name of your monitor"
  default       = "portofolio-cost-monitor"
}

variable "monitor_type" {
  type = string
  description = "Managed by aws or Custom (DIMENSIONAL or CUSTOM)"
  default = "DIMENSIONAL"

  validation {
    condition = contains(["DIMENSIONAL", "CUSTOM"], var.monitor_type)
    error_message = "Must Choose One : DIMENSIONAL or CUSTOM"
  }
}

variable "monitor_dimensional" {
  type        = string
  description = "Monitor Type = SERVICE OR LINKED_ACCOUNT"
  default     = "SERVICE"

  validation {
    condition     = var.monitor_dimensional == null || contains(["SERVICE", "LINKED_ACCOUNT"], coalesce(var.monitor_dimensional, "SERVICE"))
    error_message = "Choose One : SERVICE or LINKED_ACCOUNT"
  }
}

variable "monitor_custom" {
  type = string
  description = "Monitor Type = TAG or COST_CATEGORY"
  default = "TAG"

  validation {
    condition = contains(["TAG", "COST_CATEGORY"], var.monitor_custom)
    error_message = "Choose One : TAG or COST_CATEGORY"
  }
}

variable "target_key" {
  type = string
  description = "Key Name for Tag, (Example : Environment), or Cost Category (Example : Departement)"
  default = "Environment"
}

variable "target_value" {
  type = list(string)
  description = "Value for Monitoring"
  default = ["Production"]
}

variable "subcription_name" {
  type = string
  description = "Name of alert subcription"
  default = "pras-cost-subcription"
}

variable "frequency" {
  type = string
  description = "Choose one : DAILY, WEEKLY, IMMEDIATE"
  default = "IMMEDIATE"

  validation {
    condition = contains(["DAILY", "WEEKLY", "IMMEDIATE"], var.frequency)
    error_message = "Choose one : DALIY, WEEKLY, IMMEDIATE"
  }
}

variable "subscriber" {
  type = list(object({
    type    = string
    address = string
  }))
  description = "subcribers type"
  default = [{
    type    = "EMAIL"
    address = "your_email@example.com"
  }]

  validation {
    condition     = length(var.subscriber) > 0
    error_message = "At Least one Subcriber must be defined"
  }
}

variable "threshold_type" {
  type = string
  description = "Type of Threshold impact : ANOMALY_TOTAL_IMPACT_ABSOLUTE or ANOMALY_TOTAL_IMPACT_PERCENTAGE"
  default = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"

  validation {
    condition = contains(["ANOMALY_TOTAL_IMPACT_ABSOLUTE","ANOMALY_TOTAL_IMPACT_PERCENTAGE"], var.threshold_type)
    error_message = "Threshold type must be either ANOMALY_TOTAL_IMPACT_ABSOLUTE or ANOMALY_TOTAL_IMPACT_PERCENTAGE"
  }
}

variable "threshold_value" {
  type = number
  description = "The numeric for the threshold (e.g 100 for $100)"
  default = 100

  validation {
    condition = var.threshold_value > 0
    error_message = "Threshold value must be greater than 0"
  }
}

variable "tags" {
  description = "Map tag tambahan (key-value), akan digabung ke semua resource"
  type        = map(string)
  default     = {}
}