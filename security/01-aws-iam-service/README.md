# AWS Journey – Chapter 01: IAM Foundations

![AWS](https://img.shields.io/badge/AWS-IAM-orange?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/IaC-Terraform_v1.5+-purple?logo=terraform)
![Security](https://img.shields.io/badge/Security-CIS_Benchmark-green)

The first chapter of the *AWS Infrastructure Journey* — building a solid **Identity and Access Management (IAM)** foundation with **Terraform**, following **Least Privilege** and **AWS Well-Architected / CIS Benchmark** principles.

---

## 🎯 Objectives

1. **Enterprise account password policy** (length, complexity, rotation, reuse prevention).
2. **Group-based access** — permissions via groups, not per-user.
3. **Admin user with console access** — password can be **auto-generated OR custom**, and the user **must change it on first login**.
4. **IAM role for EC2** — S3 access via a role + instance profile, no hardcoded access keys.
5. **Consistent tagging** — provided through `default_tags`.

---

## 📁 Repository Structure

```text
01-iam-foundations/
├── providers.tf              # Terraform version, AWS provider, default_tags
├── main.tf                   # Core IAM resource definitions
├── variables.tf              # Variable declarations + validation
├── outputs.tf                # Exported outputs
├── terraform.tfvars.example  # Value template (copy locally)
└── README.md                 # Chapter documentation
```

> `terraform.tfvars` is intentionally **not committed** (listed in `.gitignore`). Copy it from `.example` before running.

---

## 🔐 Features

### 1. Account Password Policy
`aws_iam_account_password_policy` enforced at account level:
minimum **14** characters, lowercase/uppercase letters, numbers and symbols required, reuse prevention **5**, maximum age **90** days.

### 2. Group & Membership
`aws_iam_group` with the managed `AdministratorAccess` policy; the user joins the group via `aws_iam_group_membership`.

### 3. EC2 Role
- Service trust policy for `ec2.amazonaws.com` built with `aws_iam_policy_document`.
- Managed `AmazonS3ReadOnlyAccess` policy + `aws_iam_instance_profile` so the role can be attached to an EC2 instance.

---

## 🚀 Usage

```bash
cd topics/01-iam-foundations
cp terraform.tfvars.example terraform.tfvars   # then edit to your needs

terraform init
terraform plan    # review first
terraform apply   # then:
```

Sign in → **change your password** (forced). When done learning: `terraform destroy`.

---

## 🧠 Insights & Lessons Learned

- **`data` vs `resource`**: `data.aws_iam_policy_document` builds the policy JSON; `resource "aws_iam_*"` creates the actual AWS entity.
- **Attribute names ≠ variable names**: the provider attribute is `require_numbers` and `allow_users_to_change_password` (note the `s`), while variable names may differ.
- **Variable validation** catches mistakes at `plan` time, not after `apply`.
- **Sensitive outputs**: `sensitive = true` hides the value from the console, but it still lives in the state file.
- **Deprecated resource**: `aws_iam_group_membership` → modern replacement is `aws_iam_user_group_membership`.
- **Generated 14-char passwords** may be rejected by the strict policy (all character classes required) → prefer `password_length = 20`.

---

## ✅ AWS Framework Alignment

| Control | Framework |
|---|---|
| Password policy & credential hygiene | **CIS 1.8** · **FSBP IAM.1** · Well-Architected SEC |
| Group-based access | AWS IAM Best Practice · Well-Architected SEC.02 |
| Roles for services (no access keys) | Well-Architected SEC.05 · FSBP IAM |
| Managed policies (not stacked inline) | CIS 1.16 |

**Not yet covered** (roadmap): MFA (**CIS 1.2/1.5, FSBP IAM.3**), access key rotation (**FSBP IAM.7**), IAM Access Analyzer (**CIS 1.20**).

---

## 🗺️ Roadmap

- [ ] Custom S3 policy + `permissions_boundary`
- [ ] Migrate to `aws_iam_user_group_membership`
- [ ] Enforce MFA (`aws:MultiFactorAuthPresent`)
- [ ] Add `aws_iam_access_analyzer`
- [ ] Remote state backend (S3 + DynamoDB)


roles
policies
iam users
iam users group
identity providers
account setting
root access management
temporary delegation requests
