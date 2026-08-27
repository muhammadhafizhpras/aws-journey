locals {
    name_resource       = "${var.project_name}-${var.environment}"
    nat_subnet_keys     = var.single_nat_gateway ? [keys(var.public_subnet)[0]] : keys(var.public_subnet)
    nat_gateway_map     = { for subnet in local.nat_subnet_keys : subnet => subnet}
    nat_gateway_by_az   = var.enable_nat_gateway ? {
        for each, value in aws_nat_gateway.main : var.public_subnet[each].az => value.id
    } : {}
    common_tags = merge(
        {
            Project     = var.project_name
            Environment = var.environment
            ManagedBy   = "terraform"
        },
        var.tags
    )
}
