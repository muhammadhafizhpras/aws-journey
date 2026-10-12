resource "aws_ce_anomaly_monitor" "this" {
  name              = var.monitor_name
  monitor_type      = var.monitor_type
  monitor_dimension = var.monitor_type == "DIMENSIONAL" ? var.monitor_dimensional : null

 monitor_specification = var.monitor_type == "CUSTOM" ? jsonencode({
    And = []
    CostCategories = var.monitor_custom == "COST_CATEGORY" ? {
      Key          = var.target_key
      Values       = var.target_value
      MatchOptions = ["EQUALS"]
    } : null
    Dimensions = null
    Tags = var.monitor_custom == "TAG" ? {
      Key          = var.target_key
      Values       = var.target_value
      MatchOptions = ["EQUALS"]
    } : null
  }) : null

  tags = merge(local.common_tags, {
    Name = local.resource_name
  })
}
resource "aws_sns_topic" "cost_anomaly" {
  count = var.frequency == "IMMEDIATE" ? 1 : 0
  name  = "${var.project_name}-cost-anomaly-topic"

  tags = merge(local.common_tags, {
    Name = "${local.resource_name}-sns"})
}

resource "aws_sns_topic_policy" "cost_anomaly" {
  count  = var.frequency == "IMMEDIATE" ? 1 : 0
  arn    = aws_sns_topic.cost_anomaly[0].arn
  policy = data.aws_iam_policy_document.sns_policy[0].json
}

data "aws_iam_policy_document" "sns_policy" {
  count = var.frequency == "IMMEDIATE" ? 1 : 0

  statement {
    sid    = "AWSCostExplorerSNSPublishing"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["costalerts.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.cost_anomaly[0].arn]
  }
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.frequency == "IMMEDIATE" ? 1 : 0
  topic_arn = aws_sns_topic.cost_anomaly[0].arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_ce_anomaly_subscription" "this" {
  name              = var.subscription_name
  frequency         = var.frequency
  monitor_arn_list  = [aws_ce_anomaly_monitor.this.arn]

  threshold_expression {
    dimension {
      key = var.threshold_type
      values = [tostring(var.threshold_value)]
      match_options = ["GREATER_THAN_OR_EQUAL"]
    }
  }

  dynamic "subscriber" {
    for_each = var.frequency == "IMMEDIATE" ? [
      {
        type    = "SNS"
        address = aws_sns_topic.cost_anomaly[0].arn
      }
    ] : var.subscriber

    content {
      type    = subscriber.value.type
      address = subscriber.value.address
    }
  }
  tags = merge(local.common_tags, {
    Name = "${local.resource_name}"
  })
  depends_on = [
    aws_sns_topic_policy.cost_anomaly
  ]
}
