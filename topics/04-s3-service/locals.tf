locals {
    resource_name = "${var.environment}-${var.project_name}"

    common_tags = {
        Project     = var.project_name
        Environment = var.environment
        CostCenter  = var.cost_center
        Owner       = var.owner
        ManagedBy   = "Terraform"
    }
}
