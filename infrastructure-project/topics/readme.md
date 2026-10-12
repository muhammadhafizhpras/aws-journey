# AWS Journey

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-in%20progress-yellow)

> A hands-on, learning-by-doing journey through core AWS services using Terraform — documented step by step, from an IT Support background moving toward Cloud Engineering / Solutions Architecture / DevOps.

---

## Table of Contents

- [About This Repository](#about-this-repository)
- [Why This Repository Exists](#why-this-repository-exists)
- [Certifications](#certifications)
- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [Learning Path & Progress](#learning-path--progress)
- [Reusable Modules](#reusable-modules)
- [How to Use This Repository](#how-to-use-this-repository)
- [Cost Awareness](#cost-awareness)
- [Capstone Project](#capstone-project)
- [Learning Log](#learning-log)
- [Tech Stack](#tech-stack)
- [Roadmap / What's Next](#roadmap--whats-next)
- [Connect](#connect)

---

## About This Repository

This repository documents my structured, hands-on journey learning AWS through Terraform. Instead of only reading documentation or watching tutorials, every topic here is learned by **building it, breaking it, fixing it, and writing down what I understood** — the same approach I intend to bring into real infrastructure work.

Each folder under `topics/` covers one AWS service or concept, provisioned entirely with Terraform, with its own documentation describing what was built, what went wrong, and how it was solved.

This is not a finished production system — it's an evolving learning record. I'm sharing it publicly because I believe the learning process itself has value, not just the end result.

## Why This Repository Exists

- **Learning by doing** — every AWS concept here is reinforced by actually provisioning it with Terraform, not just reading about it.
- **Building Infrastructure as Code habits early** — treating infrastructure the same way software is treated: version-controlled, reviewed, and reproducible.
- **Bridging IT Support experience into Cloud/DevOps** — troubleshooting instincts from IT Support translate directly into debugging infrastructure, and this repo is where that transition is being built deliberately.
- **Transparent progress tracking** — the roadmap table below makes it clear what's done, what's in progress, and what's next, instead of a repo that looks abandoned or unclear.
- **Certification-aligned** — each topic is mapped to relevant certification domains (AWS SAA, Azure AZ-104), so the practice directly reinforces exam preparation.

## Certifications

| Certification | Status |
|---|---|
| AWS Certified Cloud Practitioner (CCP) | ✅ Completed |
| AWS Certified Solutions Architect – Associate (SAA) | ✅ Completed |
| Microsoft Certified: Azure Administrator Associate (AZ-104) | 🔄 In Progress |

## Prerequisites

To run any topic in this repository, you'll need:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.7.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with valid credentials (`aws configure`)
- An AWS account (learning/sandbox account recommended, **not** a production account)
- [tflint](https://github.com/terraform-linters/tflint) (optional, for linting)
- [pre-commit](https://pre-commit.com/) (optional, for automated checks before commit)
- Basic familiarity with the command line

## Repository Structure

```
aws-journey/
├── README.md                       # you are here
├── LICENSE
├── .gitignore
├── .tflint.hcl
├── .pre-commit-config.yaml
├── Makefile                        # shortcut commands (init/plan/apply/destroy per topic)
├── docs/
│   ├── learning-log.md             # weekly journal of what was learned
│   └── screenshots/                # architecture diagrams & console screenshots per topic
├── modules/                        # reusable Terraform modules (VPC, EC2, RDS, ALB, etc.)
│   ├── vpc/
│   ├── ec2-instance/
│   ├── security-group/
│   ├── iam-role/
│   ├── s3-bucket/
│   ├── rds-instance/
│   ├── alb/
│   ├── autoscaling-group/
│   ├── lambda-function/
│   └── ...
├── topics/                         # one folder per AWS concept/service, learned in order
│   ├── 00-terraform-fundamentals/
│   ├── 01-iam-foundations/
│   ├── 02-networking-vpc/
│   ├── 03-compute-ec2/
│   ├── 04-storage-s3/
│   ├── 05-database-rds/
│   ├── 06-load-balancing-autoscaling/
│   ├── 07-serverless-lambda/
│   ├── 08-containers-ecs-eks/
│   ├── 09-dns-cdn-route53-cloudfront/
│   ├── 10-messaging-sns-sqs/
│   ├── 11-monitoring-cloudwatch/
│   ├── 12-security-kms-secrets-manager/
│   ├── 13-terraform-state-management/
│   └── 14-cost-optimization/
└── capstone-project/                # final project combining multiple topics into one real architecture
```

Each `topics/xx-name/` folder follows the same consistent layout:

```
topics/02-networking-vpc/
├── README.md                  # what was learned, what was built, challenges solved
├── providers.tf
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars.example
```

## Learning Path & Progress

The topics are ordered intentionally — each one builds on knowledge from the previous. It's recommended to follow the order below rather than jumping around.

| # | Topic | Status | AWS Services | Certification Focus |
|---|---|---|---|---|
| 00 | [Terraform Fundamentals](./topics/00-terraform-fundamentals) | ✅ Done | - | - |
| 01 | [IAM Foundations](./topics/01-iam-foundations) | 🔄 In Progress | IAM | SAA, AZ-104 |
| 02 | [Networking (VPC)](./topics/02-networking-vpc) | ⬜ Not Started | VPC, Subnet, NAT, IGW | SAA |
| 03 | [Compute (EC2)](./topics/03-compute-ec2) | ⬜ Not Started | EC2, EBS, AMI | SAA |
| 04 | [Storage (S3)](./topics/04-storage-s3) | ⬜ Not Started | S3, Lifecycle Policy | SAA |
| 05 | [Database (RDS)](./topics/05-database-rds) | ⬜ Not Started | RDS, Multi-AZ, Read Replica | SAA |
| 06 | [Load Balancing & Auto Scaling](./topics/06-load-balancing-autoscaling) | ⬜ Not Started | ALB, ASG | SAA |
| 07 | [Serverless (Lambda)](./topics/07-serverless-lambda) | ⬜ Not Started | Lambda, API Gateway, DynamoDB | SAA |
| 08 | [Containers (ECS/EKS)](./topics/08-containers-ecs-eks) | ⬜ Not Started | ECS Fargate, EKS | SAA |
| 09 | [DNS & CDN](./topics/09-dns-cdn-route53-cloudfront) | ⬜ Not Started | Route53, CloudFront, ACM | SAA |
| 10 | [Messaging (SNS/SQS)](./topics/10-messaging-sns-sqs) | ⬜ Not Started | SNS, SQS, DLQ | SAA |
| 11 | [Monitoring (CloudWatch)](./topics/11-monitoring-cloudwatch) | ⬜ Not Started | CloudWatch, Alarms, Logs | SAA |
| 12 | [Security (KMS/Secrets Manager)](./topics/12-security-kms-secrets-manager) | ⬜ Not Started | KMS, Secrets Manager | SAA |
| 13 | [Terraform State Management](./topics/13-terraform-state-management) | ⬜ Not Started | S3, DynamoDB (backend) | - |
| 14 | [Cost Optimization](./topics/14-cost-optimization) | ⬜ Not Started | Budgets, Cost Explorer | SAA |

**Legend:** ✅ Done · 🔄 In Progress · ⬜ Not Started

> Update this table as you complete each topic — it's the fastest way for anyone (including future you) to see real progress at a glance.

## Reusable Modules

Common infrastructure patterns (VPC, EC2, RDS, ALB, etc.) are written once in `/modules` and reused across multiple topics instead of being duplicated in every folder. This mirrors how Terraform is structured in real production codebases.

| Module | Used In | Description |
|---|---|---|
| `vpc` | 02, 03, 05, 06, capstone | VPC with public/private subnets, optional NAT Gateway |
| `ec2-instance` | 03, 06, capstone | EC2 instance with user-data bootstrap support |
| `security-group` | 02, 03, 05, 06 | Reusable security group with configurable ingress/egress rules |
| `iam-role` | 01, 07, 12 | IAM role with configurable trust policy and attached policies |
| `s3-bucket` | 04, 09, capstone | S3 bucket with versioning, encryption, lifecycle rules |
| `rds-instance` | 05, capstone | RDS instance with optional Multi-AZ |
| `alb` | 06, capstone | Application Load Balancer with target group |
| `autoscaling-group` | 06, capstone | Auto Scaling Group with launch template |
| `lambda-function` | 07 | Lambda function with IAM role and optional trigger |

Each module has its own `README.md` documenting its inputs, outputs, and a usage example.

## How to Use This Repository

### 1. Clone and set up credentials
```bash
git clone https://github.com/<your-username>/aws-journey.git
cd aws-journey
aws configure
```

### 2. (First time only) Bootstrap the remote state backend
Topic `13-terraform-state-management` creates the S3 bucket + DynamoDB table used as the remote backend for every other topic. Run this one first:
```bash
cd topics/13-terraform-state-management
terraform init
terraform apply
```

### 3. Pick a topic and run it
```bash
cd topics/02-networking-vpc
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your own values
terraform init
terraform plan
terraform apply
```

### 4. Or use the Makefile shortcuts from the repo root
```bash
make init TOPIC=02-networking-vpc
make plan TOPIC=02-networking-vpc
make apply TOPIC=02-networking-vpc
make destroy TOPIC=02-networking-vpc
```

### 5. Always tear down after you're done learning
```bash
terraform destroy
```
Leaving resources running after a learning session is the most common source of unexpected AWS bills — see [Cost Awareness](#cost-awareness) below.

## Cost Awareness

Most resources in this repository fall under (or close to) the [AWS Free Tier](https://aws.amazon.com/free/), but some do not — most notably:

- **NAT Gateway** — billed hourly + per GB processed, even when idle
- **RDS Multi-AZ** — roughly double the cost of a single-AZ instance
- **ALB** — billed hourly even with no traffic
- **EIP** — free while attached to a running instance, billed when idle

**Recommended habits:**
- Always run `terraform destroy` after finishing a topic, unless actively continuing work
- Set an [AWS Budget alert](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html) on your account (covered in topic `14-cost-optimization`)
- Use `enable_nat_gateway = false` in the VPC module when NAT isn't required for the exercise

## Capstone Project

The [`capstone-project/`](./capstone-project) folder combines multiple topics into a single realistic architecture — a 3-tier web application with a public-facing load balancer, private application tier, and a managed database, backed by monitoring, DNS, and secrets management.

This is the project that demonstrates the ability to compose individual services into a coherent system, rather than just knowing each service in isolation. See its own `README.md` for the full architecture breakdown.

## Learning Log

[`docs/learning-log.md`](./docs/learning-log.md) is a running journal of weekly progress — what was learned, what broke, and what finally made it click. It exists to show the learning process over time, not just the final state of the code.

## Tech Stack

`Terraform` · `AWS` · `tflint` · `pre-commit` · `GitHub Actions` *(CI planned)*

## Roadmap / What's Next

- [ ] Finish all 15 core topics
- [ ] Complete the capstone project
- [ ] Add GitHub Actions CI for `terraform fmt`, `validate`, and `tflint` on every PR
- [ ] Add `terraform-docs` to auto-generate module documentation
- [ ] Write a companion blog post series summarizing key lessons from each topic
- [ ] Extend the same structure to a parallel `azure-journey` repository for AZ-104 practice

## Connect

- LinkedIn: *add your link*
- Blog / Medium: *add your link if you write about your learning process*

---

*This repository is a work in progress and updated regularly as new topics are completed.*
