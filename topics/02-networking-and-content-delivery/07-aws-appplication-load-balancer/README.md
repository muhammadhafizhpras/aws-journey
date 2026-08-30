load balancer name

scheme 
internet facing 
- load balancer ip address type = ["ipv4", "dual stack", "dual stack withouth ipv4"]

internal
- load balancer ip address type = ["ipv4", "dual stack"]

Network Mapping
- VPC
- IP Pools = Enable Use IPAM pool for public ipv4 addresses
- AZ and Subnet

- Security Groups

Listeners and routing
- Protocol
- Port
Default Action
- Forward to target groups
    - forward to target group (target group, weight, enable target group stickiness)

Listener Tags
- key and value

add listener

