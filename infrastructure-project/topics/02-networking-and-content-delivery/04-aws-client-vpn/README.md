1. membuat sebuah konektivitas dari local compute client ke aws environment dengan approach client vpn endpoint 

lankgah pertama membuat sertifikat mTLS server and client, and import to aws axm atau menggunakan selg signed certificate menggunakan provider tls di terraform

option standart
full manage sendiri mulai dari configure network, atuhentication, dan advanced setting lainnya intinya full manage

name = for name vpn
description vpn
network infrastructure
vpc or tgw

if vpc parameter = vpc id, security group, 
endpoint ip address type = ipv4, ipv6, dual stack
traffic ip address type = ipv4, ipv6, dual stack

client ipv4 cidr


authentication
server certificate arn = certificate untuk server yang harus kita buat sendiri

authentication options
user mutual authentication = client certificate arn


user user-based authentication
active directory authentication 
directory id

federated authentication
saml provider arn
self service saml provider arn

optional
enable client connect handler = lambda function to authorize connections based on device, user and connection atributes
enable self service portal = web portal for user to download vpn client and configuration files
enable client login baner = custom text banner displayed when vpn session is establised

dns configuration
dns servers

conection protocol
tunnel mode
full tunnel = all client traffic is routed throught the vpn tunnel
split tunnel = only traffic matching client vpn endpoint routes id routed throught vpn tunnel

transport protocol
udp or tcp

vpn port


