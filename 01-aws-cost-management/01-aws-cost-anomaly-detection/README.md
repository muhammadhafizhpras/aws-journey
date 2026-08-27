# AWS Cost Anomaly Detection

This Terraform module provisions AWS Cost Anomaly Detection resources to automatically detect unusual spending patterns in your AWS accounts.

## Overview

AWS Cost Anomaly Detection uses machine learning to identify anomalous spending patterns, helping you:
- Detect cost leaks early
- Reduce manual monitoring overhead
- Identify root causes of spending spikes

## How It Works

1. **Learn Historical Patterns** - System learns your spending patterns over time (considering day of week, seasonal trends, business growth)
2. **Continuous Monitoring** - Daily comparison of actual spending against expected costs based on historical patterns
3. **Anomaly Detection** - Flags spending that significantly exceeds statistical thresholds (not just normal increases, but spikes)
4. **Financial Impact Assessment** - Calculates total extra costs caused by each anomaly

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    AWS Cost Anomaly Detection                   │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌──────────────────────────────────┐   │
│  │  Anomaly Monitor │───▶│     Anomaly Subscription         │   │
│  │                  │    │  - Frequency (DAILY/WEEKLY/      │   │
│  │  Types:          │    │    IMMEDIATE)                    │   │
│  │  - DIMENSIONAL   │    │  - Threshold (Absolute/Percentage)│  │
│  │    - SERVICE     │    │  - Subscribers (Email/SNS)       │   │
│  │    - LINKED_ACCOUNT                    │                   │
│  │  - CUSTOM        │    └──────────────────────────────────┘   │
│  │    - TAG         │              │                             │
│  │    - COST_CATEGORY              ▼                             │
│  └─────────────────┘    ┌──────────────────────────────────┐   │
│                         │         SNS Topic (IMMEDIATE)    │   │
│                         │         + Email Subscription      │   │
│                         └──────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Prerequisites

- Terraform >= 1.0
- AWS Provider >= 5.0
- AWS account with Cost Explorer enabled
- Appropriate IAM permissions for Cost Explorer and SNS

## Usage

```hcl
module "cost_anomaly_detection" {
  source = "./01-aws-cost-management/01-aws-cost-anomaly-detection"

  environment      = "production"
  project_name     = "my-app"
  monitor_name     = "my-app-cost-monitor"
  monitor_type     = "DIMENSIONAL"
  monitor_dimensional = "SERVICE"
  subscription_name = "my-app-cost-alerts"
  frequency        = "DAILY"
  threshold_type   = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
  threshold_value  = 20
  subscriber = [{
    type    = "EMAIL"
    address = "alerts@example.com"
  }]
}
```

For immediate alerts via SNS:
```hcl
module "cost_anomaly_detection" {
  source = "./01-aws-cost-management/01-aws-cost-anomaly-detection"

  environment       = "production"
  project_name      = "my-app"
  monitor_name      = "my-app-cost-monitor"
  monitor_type      = "DIMENSIONAL"
  monitor_dimensional = "SERVICE"
  subscription_name = "my-app-immediate-alerts"
  frequency         = "IMMEDIATE"
  notification_email = "alerts@example.com"
  threshold_type    = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
  threshold_value   = 100
}
```

## Configuration Options

### Required Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `environment` | string | Environment name (e.g., prod, staging) | `"prod"` |
| `project_name` | string | Project name for resource naming | `"portofolio"` |
| `monitor_name` | string | Name of the anomaly monitor | `"portofolio-cost-monitor"` |
| `subscription_name` | string | Name of the alert subscription | `"pras-cost-subcription"` |

### Monitor Configuration

| Variable | Type | Description | Default | Valid Values |
|----------|------|-------------|---------|--------------|
| `monitor_type` | string | Monitor type: AWS-managed or custom | `"DIMENSIONAL"` | `DIMENSIONAL`, `CUSTOM` |
| `monitor_dimensional` | string | Dimension for DIMENSIONAL monitors | `"SERVICE"` | `SERVICE`, `LINKED_ACCOUNT` |
| `monitor_custom` | string | Custom monitor type | `"TAG"` | `TAG`, `COST_CATEGORY` |
| `target_key` | string | Tag key or Cost Category key | `"Environment"` | - |
| `target_value` | list(string) | Values to monitor | `["Production"]` | - |

**Monitor Types:**
- **DIMENSIONAL** - AWS-managed monitors
  - `SERVICE` - Monitor anomalies per AWS service (EC2, S3, RDS, etc.)
  - `LINKED_ACCOUNT` - Monitor per AWS account (ideal for AWS Organizations)
- **CUSTOM** - Custom expression-based monitors
  - `TAG` - Monitor based on cost allocation tags
  - `COST_CATEGORY` - Monitor based on defined Cost Categories

### Alert Subscription Configuration

| Variable | Type | Description | Default | Valid Values |
|----------|------|-------------|---------|--------------|
| `frequency` | string | Alert frequency | `"IMMEDIATE"` | `DAILY`, `WEEKLY`, `IMMEDIATE` |
| `notification_email` | string | Email for IMMEDIATE alerts via SNS | `"your_email@example.com"` | - |
| `subscriber` | list(object) | Subscribers for DAILY/WEEKLY alerts | `[{type="EMAIL", address="your_email@example.com"}]` | - |
| `threshold_type` | string | Threshold metric type | `"ANOMALY_TOTAL_IMPACT_ABSOLUTE"` | `ANOMALY_TOTAL_IMPACT_ABSOLUTE`, `ANOMALY_TOTAL_IMPACT_PERCENTAGE` |
| `threshold_value` | number | Threshold value | `100` | > 0 |

**Frequency Options:**
- `IMMEDIATE` - Real-time alerts via SNS (requires `notification_email`)
- `DAILY` - Daily summary emails (uses `subscriber` list)
- `WEEKLY` - Weekly summary emails (uses `subscriber` list)

**Threshold Types:**
- `ANOMALY_TOTAL_IMPACT_ABSOLUTE` - Absolute dollar amount (e.g., $100)
- `ANOMALY_TOTAL_IMPACT_PERCENTAGE` - Percentage increase (e.g., 20%)

### Optional Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `aws_region` | string | AWS region | `"ap-southeast-3"` |
| `tags` | map(string) | Additional tags for all resources | `{}` |

## Outputs

| Output | Description |
|--------|-------------|
| `anomaly_monitor_arn` | ARN of the Cost Anomaly Monitor |
| `anomaly_subscription_arn` | ARN of the Cost Anomaly Subscription |
| `sns_topic_arn` | ARN of SNS Topic (only when frequency = IMMEDIATE) |
| `monitoring_summary` | Summary object with monitor configuration |

## Important Notes

### IMMEDIATE Frequency Limitation
Per AWS API constraints, **IMMEDIATE** frequency only supports SNS topic subscriptions. When using `frequency = "IMMEDIATE"`:
- An SNS topic is automatically created
- Email subscription is added to the SNS topic
- The `subscriber` variable is ignored
- Use `notification_email` for the recipient

For `DAILY` or `WEEKLY` frequencies:
- Email subscriptions are created directly
- The `notification_email` variable is ignored
- Use the `subscriber` list (supports multiple recipients)

### Cost Category & Tag Prerequisites
- **Cost Categories** must be defined in AWS Cost Management before use
- **Cost Allocation Tags** must be activated in AWS Billing Console before use

## Examples

### Example 1: Service-Level Monitoring with Daily Alerts
```hcl
environment      = "production"
project_name     = "ecommerce-platform"
monitor_name     = "ecommerce-service-monitor"
monitor_type     = "DIMENSIONAL"
monitor_dimensional = "SERVICE"
subscription_name = "ecommerce-daily-alerts"
frequency        = "DAILY"
threshold_type   = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
threshold_value  = 25
subscriber = [
  { type = "EMAIL", address = "finops@example.com" },
  { type = "EMAIL", address = "engineering@example.com" }
]
```

### Example 2: Linked Account Monitoring for Organizations
```hcl
environment      = "production"
project_name     = "org-monitoring"
monitor_name     = "org-account-monitor"
monitor_type     = "DIMENSIONAL"
monitor_dimensional = "LINKED_ACCOUNT"
subscription_name = "org-immediate-alerts"
frequency        = "IMMEDIATE"
notification_email = "cloud-finance@example.com"
threshold_type   = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
threshold_value  = 500
```

### Example 3: Tag-Based Custom Monitoring
```hcl
environment      = "production"
project_name     = "microservices"
monitor_name     = "prod-environment-monitor"
monitor_type     = "CUSTOM"
monitor_custom   = "TAG"
target_key       = "Environment"
target_value     = ["Production"]
subscription_name = "prod-tag-alerts"
frequency        = "WEEKLY"
threshold_type   = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
threshold_value  = 15
subscriber = [
  { type = "EMAIL", address = "platform-team@example.com" }
]
```

## Deployment

```bash
# Initialize
terraform init

# Plan
terraform plan -var-file="terraform.tfvars"

# Apply
terraform apply -var-file="terraform.tfvars"
```

## Cleanup

```bash
terraform destroy -var-file="terraform.tfvars"
```

## References

- [AWS Cost Anomaly Detection Documentation](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-anomaly-detection.html)
- [Terraform AWS Provider - CE Anomaly Monitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_monitor)
- [Terraform AWS Provider - CE Anomaly Subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_subscription)