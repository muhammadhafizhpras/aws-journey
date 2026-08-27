resource "aws_ec2_transit_gateway" "this" {
  description                        = var.description
  amazon_side_asn                    = var.amazon_sid_asn
  auto_accept_shared_attachments     = var.auto_accept_shared_attachments
  default_route_table_association    = var.default_route_table_association
  default_route_table_propagation    = var.default_route_table_propagation
  dns_support                        = var.dns_support
  vpn_ecmp_support                   = var.vpn_ecmp_support
  multicast_support                  = var.multicast_support
  security_group_referencing_support = var.security_group_referencing_support

  tags = merge(local.common_tags, {
    Name = "${local.resource_name}-TGW"
  })
}