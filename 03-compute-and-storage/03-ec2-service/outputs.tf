output "ssh_key_name" {
  description = "Nama Key Pair AWS yang terdaftar"
  value       = aws_key_pair.generated_key.key_name
}

output "ssh_private_key_path" {
  description = "Lokasi file Private Key (.pem) lokal"
  value       = local_sensitive_file.private_key_pem.filename
}

output "ssh_command" {
  description = "Perintah SSH langsung untuk terhubung ke setiap EC2 Instance"
  value = {
    for k, v in aws_instance.ec2 : k => (
      v.public_ip != "" 
      ? "ssh -i ${local_sensitive_file.private_key_pem.filename} ubuntu@${v.public_ip}" 
      : "ssh -i ${local_sensitive_file.private_key_pem.filename} ubuntu@${v.private_ip} (via Bastion/VPN)"
    )
  }
}

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

output "ec2_summary" {
  description = "Rangkuman lengkap status dan informasi IP dari seluruh EC2 Instance"
  value = {
    for k, v in aws_instance.ec2 : k => {
      instance_id = v.id
      public_ip   = v.public_ip != "" ? v.public_ip : "No Public IP"
      private_ip  = v.private_ip
      subnet_id   = v.subnet_id
      subnet_type = var.ec2_instance[k].subnet_type
    }
  }
}