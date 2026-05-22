module "jump_vm" {
  source = "github.com/foggykitchen/terraform-az-fk-compute"

  name                = "foggykitchen-jump-vm"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  deployment_mode = "vm"
  subnet_id       = module.vnet.subnet_ids["foggykitchen-private-subnet"]

  admin_username = "azureuser"
  ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
  vm_size        = "Standard_B1s"

  attach_nsg_to_nic = true
  nsg_id            = module.jump_vm_nsg.id

  image_reference = {
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
