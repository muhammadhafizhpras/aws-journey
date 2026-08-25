# 📊 AWS Budget Configuration & Monitoring Blueprint

This documentation contains detailed descriptions, notification architecture, and implementation guides for **AWS Budgets** to monitor, control, and prevent cost overruns and inefficient resource usage in AWS environments.

---

## 📌 1. Overview

AWS Budgets provides proactive notifications (via Email & SNS) when estimated or actual usage of costs, usage, or commitment utilization (Reserved Instances / Savings Plans) approaches or exceeds defined thresholds.

This project uses **Terraform** to manage AWS Budgets as Infrastructure as Code (IaC), enabling consistent, version-controlled, and reproducible deployments.

### 🔧 AWS Services Used

| Service | Description |
|---------|-------------|
| **AWS Budgets** | Primary service for creating, managing, and monitoring AWS cost/usage budgets. Supports budget types: COST, USAGE, RI_UTILIZATION, RI_COVERAGE, SAVING_PLAN_COVERAGE. |
| **AWS SNS (Simple Notification Service)** | Sends alert notifications to email, SMS, or integrations with Slack/Teams/PagerDuty via subscriptions. |
| **AWS Cost Explorer** | Backend cost analysis engine used by AWS Budgets to calculate actual spend and forecasted spend. |
| **AWS IAM** | Manages permissions for Terraform to create/manage budgets (requires `budgets:*` permissions). |

---

## 🛠️ 2. Architecture & Terraform Components

### File Structure

```
02-aws-budget-service/
├── main.tf              # Main resource: aws_budgets_budget
├── variable.tf          # All input variable definitions with validation
├── locals.tf            # Data transformations (tag filter formatting, naming prefix)
├── outputs.tf           # Output budget ID, name, ARN
├── providers.tf         # AWS provider configuration & default tags
├── terraform.tfvars     # Actual variable values (do not commit to git)
├── terraform.tfvars.example  # Configuration template
└── README.md            # This documentation
```

### Main Resource: `aws_budgets_budget`

This resource creates an AWS Budget with:
- **Budget configurations** (name, type, limit, time period)
- **Cost types** (include/exclude: credit, discount, tax, refund, etc.)
- **Cost filters** (Service, LinkedAccount, Region, TagKeyValue)
- **Notifications** (threshold alerts with email subscribers)

---

## 📋 3. Complete Parameter & Variable Definitions

### A. Provider & Global Settings (`providers.tf`, `variable.tf`)

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `aws_region` | string | `ap-southeast-3` | AWS region where budget is created (Budgets is a global service but created per region). |
| `environment` | string | `dev` | Environment name: `dev`, `staging`, `prod`. Used for tagging & naming. |
| `project_name` | string | `portofolio` | Project/application name. Used for resource name prefix & tagging. |

### B. Budget Core Configuration

| Variable | Type | Required | Description | Valid Values |
|----------|------|----------|-------------|--------------|
| `budget_name` | string | **Yes** | Unique name for the AWS Budget. Must be unique per account per region. | - |
| `budget_type` | string | No (default: `COST`) | Type of budget to monitor. | `COST`, `USAGE`, `RI_UTILIZATION`, `RI_COVERAGE`, `SAVING_PLAN_COVERAGE` |
| `time_unit` | string | No (default: `MONTHLY`) | Budget evaluation period. | `DAILY`, `MONTHLY`, `QUARTERLY`, `ANNUALLY` |
| `time_start` | string | No (default: null) | Budget start time in RFC3339 format. Null = start immediately. | Example: `2026-08-01T00:00:00Z` |
| `time_end` | string | No (default: null) | Budget end time. Null = never expires (recurring). | Example: `2026-12-31T23:59:59Z` |
| `budget_limit` | object | **Yes** | Object with `amount` (string) and `unit` (string). | `amount`: "100", `unit`: "USD" |

#### Budget Types Detail

| Type | Use Case |
|------|----------|
| `COST` | Monitor financial spend (USD) - actual & forecasted |
| `USAGE` | Monitor usage quantity (GB, Hours, Requests, etc.) |
| `RI_UTILIZATION` | Reserved Instance utilization percentage (target: high) |
| `RI_COVERAGE` | Portion of workload covered by RI/Savings Plan |
| `SAVING_PLAN_COVERAGE` | Portion of workload covered by Savings Plan |

### C. Cost Types (Cost Calculation Options)

All boolean, defaults vary. Controls what is included in budget calculation:

| Variable | Default | Description |
|----------|---------|-------------|
| `include_credit` | `false` | Include AWS Credits (promo, free tier) |
| `include_discount` | `true` | Include volume/RI/SP discounts |
| `include_other_subscription` | `true` | Include other subscription costs (Marketplace, etc.) |
| `include_recurring` | `true` | Include recurring costs (EC2 running, RDS, etc.) |
| `include_refund` | `true` | Include refunds |
| `include_subscription` | `true` | Include subscription upfront costs |
| `include_support` | `true` | Include AWS Support plan costs |
| `include_tax` | `true` | Include taxes |
| `include_upfront` | `true` | Include RI/SP upfront costs |
| `use_blended` | `false` | Use blended rate (for consolidated billing) |
| `use_amortized` | `false` | Use amortized cost (amortize RI/SP upfront per month) |

> **Note:** For production `COST` budgets, recommended: `use_amortized = true`, `include_credit = false`, `include_refund = false`.

### D. Cost Filters (Scope & Filtering)

#### 1. `cost_filters` - Standard AWS Dimension Map

```hcl
cost_filters = {
  Service = ["Amazon EC2 - Compute", "Amazon S3 - Storage"]
  LinkedAccount = ["123456789012"]
  Region = ["ap-southeast-3"]
}
```

| Filter Key | Description | Example Values |
|------------|-------------|----------------|
| `Service` | AWS Service (must exact match Cost Explorer name) | `Amazon EC2 - Compute`, `Amazon RDS - Database` |
| `LinkedAccount` | Account ID in Organization | `123456789012` |
| `Region` | AWS Region | `ap-southeast-3`, `us-east-1` |
| `UsageType` | Specific usage type | `BoxUsage:t3.medium`, `TimedStorage-ByteHrs` |
| `Operation` | API Operation | `RunInstances`, `GetObject` |
| `PurchaseOption` | Purchase option | `On Demand`, `Reserved`, `Savings Plans` |

#### 2. `cost_filter_tags` - Filter by Resource Tags

```hcl
cost_filter_tags = {
  Environment = ["Production", "Staging"]
  Project     = ["my-app"]
  Owner       = ["team-platform"]
}
```

- Automatically formatted as `TagKeyValue` = `Environment$Production` in `locals.tf`
- Enables per-project/environment/team budgets without multiple budget resources

### E. Notifications (Alert Thresholds)

```hcl
notifications = [{
  comparison_operator = "GREATER_THAN"     # GREATER_THAN, LESS_THAN, EQUAL_TO
  threshold           = 80                 # Threshold value
  threshold_type      = "PERCENTAGE"       # PERCENTAGE or ABSOLUTE_VALUE
  notification_type   = "ACTUAL"           # ACTUAL or FORECASTED
  subscriber_email_addresses = ["devops@company.com", "finance@company.com"]
}]
```

| Field | Type | Required | Description | Valid Values |
|-------|------|----------|-------------|--------------|
| `comparison_operator` | string | Yes | Comparison operator | `GREATER_THAN`, `LESS_THAN`, `EQUAL_TO` |
| `threshold` | number | Yes | Threshold value | 0-100 for PERCENTAGE, any for ABSOLUTE_VALUE |
| `threshold_type` | string | Yes | Threshold type | `PERCENTAGE` (of budget limit), `ABSOLUTE_VALUE` (absolute amount) |
| `notification_type` | string | Yes | Calculation basis | `ACTUAL` (current spend), `FORECASTED` (end-of-period prediction) |
| `subscriber_email_addresses` | list(string) | Yes | Recipient email list | Array of valid emails |

#### Notification Matrix Best Practice

| Alert Level | Threshold | Type | Basis | Purpose |
|-------------|-----------|------|-------|---------|
| **Info** | 50% | PERCENTAGE | ACTUAL | Early awareness mid-month |
| **Warning** | 80% | PERCENTAGE | ACTUAL | Evaluate resources, scale down if needed |
| **Critical** | 100% | PERCENTAGE | FORECASTED | Predicted over-budget, immediate action required |

---

## 🚀 4. Deployment Guide

### Prerequisites

1. **Terraform** >= 1.5.0 installed
2. **AWS CLI** configured with credentials having permissions:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [{
       "Effect": "Allow",
       "Action": [
         "budgets:*",
         "sns:CreateTopic",
         "sns:Subscribe",
         "sns:SetTopicAttributes"
       ],
       "Resource": "*"
     }]
   }
   ```
3. **AWS Account** with billing access enabled

### Deployment Steps

```bash
# 1. Navigate to project directory
cd aws-infrastructure-journey/01-foundations-and-security/02-aws-budget-service

# 2. Copy template and edit values
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with actual values (email, budget amount, etc.)

# 3. Initialize Terraform
terraform init

# 4. Validate configuration
terraform validate

# 5. Preview changes
terraform plan

# 6. Apply (confirm with 'yes')
terraform apply
```

### Verify Deployment

```bash
# Check outputs
terraform output

# Or check in AWS Console:
# Billing & Cost Management > Budgets > Budgets
```

### Update Budget

```bash
# Edit terraform.tfvars then:
terraform plan
terraform apply
```

### Destroy Budget

```bash
terraform destroy
```

---

## 📝 5. Complete Configuration Example (`terraform.tfvars`)

```hcl
# Provider & Global
aws_region      = "ap-southeast-3"
environment     = "production"
project_name    = "ecommerce-platform"

# Budget Core
budget_name     = "prd-ecommerce-monthly-cost-guardrail"
budget_type     = "COST"
time_unit       = "MONTHLY"
time_start      = "2026-01-01T00:00:00Z"
time_end        = null  # Recurring without end
budget_limit    = {
  amount = "5000"
  unit   = "USD"
}

# Cost Types (Production recommended)
include_credit              = false
include_discount            = true
include_other_subscription  = true
include_recurring           = true
include_refund              = false
include_subscription        = true
include_support             = true
include_tax                 = true
include_upfront             = true
use_blended                 = false
use_amortized               = true

# Scope: Filter Service & Tag
cost_filters = {
  Service = [
    "Amazon EC2 - Compute",
    "Amazon RDS - Database",
    "Amazon S3 - Storage",
    "Amazon CloudFront - Content Delivery"
  ]
}

cost_filter_tags = {
  Environment = ["Production"]
  Project     = ["ecommerce-platform"]
}

# Alert Notifications (3-tier)
notifications = [
  {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["devops@company.com"]
  },
  {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["devops@company.com", "finance@company.com"]
  },
  {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["devops@company.com", "finance@company.com", "cto@company.com"]
  }
]
```

---

## 🤝 6. Maintenance & Best Practices

### Periodic Review

| Frequency | Activity |
|-----------|----------|
| **Monthly** | Review actual vs budget, adjust forecast accuracy |
| **Quarterly** | Adjust `budget_limit.amount` based on growth trends |
| **Annually** | Evaluate `budget_type` & `cost_filters` alignment with architecture |

### Cost Optimization Tips

1. **Use `use_amortized = true`** for RI/SP budgets to distribute upfront costs monthly
2. **Filter by Tag** (`cost_filter_tags`) instead of Service for per-project granularity
3. **Multi-tier alerts** (50%, 80%, 100% forecasted) for early warning system
4. **SNS Integration** → Lambda → Slack/Teams for real-time alerts in team channels

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Budget not visible in Console | Check region (Budget is global but created per region), wait 5-10 minutes |
| Alerts not delivered | Verify email subscription in SNS Console, check spam folder |
| Forecast inaccurate | Need minimum 5-7 days historical data for reliable forecast |
| Error "Budget name already exists" | Change `budget_name` or `terraform destroy` the old one first |

---

## 📚 7. References

- [AWS Budgets User Guide](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/budgets-managing.html)
- [Terraform AWS Budgets Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget)
- [AWS Cost Explorer API](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-api.html)
- [Well-Architected Cost Optimization Pillar](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/welcome.html)

---

## 📄 License

This project is part of *AWS Infrastructure Journey* - Learning & Portfolio Project.