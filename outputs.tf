output "vpn_ip" {
  value       = aws_eip.vpn_ip.public_ip
  description = "public ip of the vpn server"
}

output "linknode_ips" {
  value       = module.ec2_cluster.private_ip
  description = "private ips of the linknode server"
}
