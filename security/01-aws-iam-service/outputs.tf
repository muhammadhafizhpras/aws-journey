output "admin_user_name" {
  description = "Nama IAM User yang dibuat"
  value       = aws_iam_user.user.name
}

output "admin_user_arn" {
  description = "Amazon Resource Name (ARN) dari IAM User"
  value       = aws_iam_user.user.arn
}

output "admin_group_name" {
  description = "Nama IAM Group Administrators"
  value       = aws_iam_group.group.name
}

output "ec2_role_arn" {
  description = "ARN dari IAM Role untuk EC2 Instance"
  value       = aws_iam_role.ec2_s3_readonly.arn
}

output "ec2_instance_profile_name" {
  description = "Nama Instance Profile yang dikaitkan ke EC2 Role"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "admin_initial_password" {
  description = "Password awal (di-generate). Wajib diganti saat login pertama."
  value       = aws_iam_user_login_profile.user_console.password
  sensitive   = true
}