resource "azurerm_linux_virtual_machine" "foggykitchen_jump_vm" {
  name                = "foggykitchen_jump_vm"
  computer_name       = "fkprivatevm"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.foggykitchen_jump_vm_nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.public_private_key_pair.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<EOF
#cloud-config
package_update: true
runcmd:
  - curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  - curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  - install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
EOF
  )
}