output "Vault_Node_Public-IP" {
  value = {
    for instance in aws_instance.vault-node :
    instance.id => instance.public_ip
  }
}

output "Load_Balancer_DNS-Name" {
  value = aws_lb.application-lb.dns_name
}
