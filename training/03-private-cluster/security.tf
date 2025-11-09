resource "azurerm_network_security_group" "foggykitche_jump_vm_nsg" {
  name                = "foggykitche_jump_vm_nsg"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  security_rule {
    name                       = "ssh-from-bastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = [azurerm_subnet.foggykitchen_bastion_subnet.address_prefixes[0]]
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "foggykitche_jump_vm_nsg_nic_association" {
  network_interface_id      = azurerm_network_interface.foggykitchen_jump_vm_nic.id
  network_security_group_id = azurerm_network_security_group.foggykitche_jump_vm_nsg.id
}

