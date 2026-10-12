output "vpc_id" {
  description = "ID VPC yang dibuat"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Map nama subnet -> ID subnet publik"
  value       = { for k, v in aws_subnet.public : k => v.id }
}
output "private_subnet_ids" {
  description = "Map nama subnet -> ID subnet private"
  value       = { for k, v in aws_subnet.private : k => v.id }
}
output "nat_gateway_ids" {
  description = "List ID NAT Gateway yang aktif"
  value       = [for ng in aws_nat_gateway.main : ng.id]
}

output "security_group_web_id" {
  description = "ID security group web tier"
  value       = aws_security_group.app.id
}

output "route_table_public_id" {
  description = "ID route table publik"
  value       = aws_route_table.public.id
}
