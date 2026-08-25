#IAM Account Password Policy
resource "aws_iam_account_password_policy" "strict_policy" {
    minimum_password_length         = var.minimum_password_length
    require_lowercase_characters    = var.require_lowercase_characters
    require_uppercase_characters    = var.require_uppercase_characters
    require_numbers                  = var.require_numbers
    require_symbols                 = var.require_symbols
    allow_users_to_change_password   = var.allow_user_to_change_password
    password_reuse_prevention       = var.password_reuse_prevention
    max_password_age                = var.max_password_age
}

#IAM User Group
resource "aws_iam_group" "group" {
    name = var.group_name
}

resource "aws_iam_group_policy_attachment" "group_policy_attach" {
    group       = aws_iam_group.group.name
    policy_arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#IAM User
resource "aws_iam_user" "user" {
    name = var.user_name
    path = "/"

    tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_user_login_profile" "user_console" {
  user                    = aws_iam_user.user.name
  password                = var.password_mode == "custom" ? var.custom_password : null
  password_length         = var.minimum_password_length
  password_reset_required = true

}

#Add User to Group
resource "aws_iam_group_membership" "team" {
  name  = "${var.group_name}-membership"
  users = [aws_iam_user.user.name]
  group = aws_iam_group.group.name
}

#IAM ROLE
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_s3_readonly" {
  name               = var.ec2_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "s3_readonly_attach" {
  role       = aws_iam_role.ec2_s3_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.ec2_role_name}-profile"
  role = aws_iam_role.ec2_s3_readonly.name
}