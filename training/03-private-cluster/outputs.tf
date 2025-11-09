output "jump_private_key_openssh" {
  value     = tls_private_key.public_private_key_pair.private_key_openssh
  sensitive = true
}

# (opcjonalnie)
output "jump_public_key_openssh" {
  value     = tls_private_key.public_private_key_pair.public_key_openssh
  sensitive = false
}
