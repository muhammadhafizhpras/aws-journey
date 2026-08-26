resource "aws_ce_anomaly_monitor" "this" {
  name              = var.monitor_name
  monitor_type      = var.monitor_type
  monitor_dimension = var.monitor_type == "DIMENSIONAL" ? var.monitor_dimensional : null

  tags = merge(local.common_tags, {
    Name = "${local.resource_name}"})
}

resource "aws_ce_anomaly_subscription" "this" {
  name              = var.subcription_name
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
    for_each = var.subscriber
    content {
      type = subscriber.value.type
      address = subscriber.value.address
    }
  }
  tags = merge(local.common_tags, {
    Name = "${local.resource_name}"
  })
}
