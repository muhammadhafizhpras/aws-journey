resource "aws_budgets_budget" "this" {
  name              = var.budget_name
  budget_type       = var.budget_type
  limit_amount      = var.budget_limit.amount
  limit_unit        = var.budget_limit.unit
  time_unit         = var.time_unit
  time_period_start = var.time_start
  time_period_end   = var.time_end

  cost_types {
    include_credit              = var.include_credit
    include_discount            = var.include_discount
    include_other_subscription  = var.include_other_subscription
    include_recurring           = var.include_recurring
    include_refund              = var.include_refund
    include_subscription        = var.include_subscription#
    include_support             = var.include_support
    include_tax                 = var.include_tax
    include_upfront             = var.include_upfront
    use_blended                 = var.use_blended
    use_amortized               = var.use_amortized
  }


  dynamic "cost_filter" {
    for_each = var.cost_filters
    content {
      name = cost_filter.key
      values = cost_filter.value
    }
  }

  dynamic "cost_filter" {
    for_each = length(local.formatted_tag_filters) > 0 ? [1] : []
    content {
      name = "TagKeyValue"
      values = local.formatted_tag_filters
    }
  }

  dynamic "notification" {
    for_each = var.notifications
    content {
      comparison_operator           = notification.value.comparison_operator
      threshold                     = notification.value.threshold
      threshold_type                = notification.value.threshold_type
      notification_type             = notification.value.notification_type
      subscriber_email_addresses    = notification.value.subscriber_email_addresses
    }
  }
}

