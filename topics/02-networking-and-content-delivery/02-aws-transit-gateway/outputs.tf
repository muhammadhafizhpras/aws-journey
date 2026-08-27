output "transit_gateway_arn" {
  description = "ARN dari Transit Gateway"
  value       = aws_ec2_transit_gateway.this.arn
}

output "vpc_attachments" {
  description = "Connection VPC each other"
  value = aws_ec2_transit_gateway_vpc_attachment.this.arn
}