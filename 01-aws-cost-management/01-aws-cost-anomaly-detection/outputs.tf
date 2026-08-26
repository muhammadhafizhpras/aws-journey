output "anomaly_monitor_id" {
  description = "ID from AWS Cost Anomaly Monitor"
  value       = aws_ce_anomaly_monitor.this.id
}

output "anomaly_monitor_arn" {
  description = "ARN from AWS Cost Anomaly Monitor"
  value       = aws_ce_anomaly_monitor.this.arn
}

output "anomaly_subscription_arn" {
  description = "ARN from AWS Cost Anomaly Subscription (Alarm)"
  value       = aws_ce_anomaly_subscription.this.arn
}

output "monitoring_summary" {
  description = "Summary config cost monitoring"
  value = {
    monitor_name      = var.monitor_name
    monitor_type      = var.monitor_type
    monitor_dimension = var.monitor_dimensional
    frequency         = var.frequency
    threshold         = "$${var.threshold_value} (Absolute)"
    notification_to   = var.subscriber[0].address
  }
}