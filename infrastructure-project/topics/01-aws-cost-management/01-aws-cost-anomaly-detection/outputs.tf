output "anomaly_monitor_arn" {
  description = "ARN dari AWS Cost Anomaly Monitor"
  value       = aws_ce_anomaly_monitor.this.arn
}

output "anomaly_subscription_arn" {
  description = "ARN dari AWS Cost Anomaly Subscription"
  value       = aws_ce_anomaly_subscription.this.arn
}

output "sns_topic_arn" {
  description = "ARN dari SNS Topic (hanya ada jika frequency = IMMEDIATE)"
  value       = var.frequency == "IMMEDIATE" ? aws_sns_topic.cost_anomaly[0].arn : null
}

output "monitoring_summary" {
  description = "Ringkasan konfigurasi Cost Anomaly Monitoring"
  value = {
    monitor_name      = aws_ce_anomaly_monitor.this.name
    subscription_name = aws_ce_anomaly_subscription.this.name
    frequency         = var.frequency
    notification_to   = var.frequency == "IMMEDIATE" ? var.notification_email : var.subscriber[0].address
    threshold         = "${var.threshold_type} >= ${var.threshold_value}"
  }
}