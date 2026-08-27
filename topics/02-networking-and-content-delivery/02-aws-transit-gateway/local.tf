locals {
  resource_name = "${var.environment}-${var.project_name}"
  common_tags = merge(
    {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "Terraform"
    },
    var.tags
  )
}