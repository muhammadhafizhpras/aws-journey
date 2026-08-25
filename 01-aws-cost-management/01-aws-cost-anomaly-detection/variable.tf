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
}
variable "frequency" {
  type = string
  description = "Choose one : DAILY, WEEKLY, IMMEDIATE"
  default = "IMMEDIATE"

  validation {
    condition = contains(["DAILY", "WEEKLY", "IMMEDIATE"], var.frequency)
    error_message = "Must Choose one : DALIY, WEEKLY, IMMEDIATE"
  }
}

variable "monitor_name" {
  type = list(string)
  description = "List of Monitor ARNs"
}

variable "subscriber" {
  type = list(object({
    type = string
    address = string
  }))
  description = "subcribers type"
  default = [ {
    type = "EMAIL"
    address = "your_email@example.com"
  } ]

  validation {
    condition = length(var.subscriber) > 0
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