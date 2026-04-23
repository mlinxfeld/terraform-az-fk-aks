output "jump_private_key_openssh" {
  value     = tls_private_key.public_private_key_pair.private_key_openssh
  sensitive = true
}

# (opcjonalnie)
output "jump_public_key_openssh" {
  value     = tls_private_key.public_private_key_pair.public_key_openssh
  sensitive = false
}

output "jump_vm_private_ip" {
  value = module.jump_vm.vm_private_ip
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "natgw_public_ip" {
  value = module.natgw_public_ip.ip_address
}
