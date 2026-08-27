output "s3_bucket_id" {
  description = "Name S3 Bucket"
  value       = aws_s3_bucket.main.id 
}

output "s3_bucket_arn" {
  description = "Amazon Resource Name"
  value       = aws_s3_bucket.main.arn 
}

output "s3_bucket_bucket_domain_name" {
  description = "FQDN from Bucket (Exmaple: bucketname.s3.amazonaws.com)"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "s3_bucket_bucket_regional_domain_name" {
  description = "FQDN regional from Bucket (for Cloudfront)"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "kms_key_arn" {
  description = "ARN dari KMS Key yang dibuat untuk enkripsi bucket ini"
  value       = aws_kms_key.s3_key.arn
}

output "kms_key_id" {
  description = "ID dari KMS Key"
  value       = aws_kms_key.s3_key.key_id
}