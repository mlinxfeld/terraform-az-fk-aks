module "jump_vm_nsg" {
  source = "github.com/foggykitchen/terraform-az-fk-nsg"

  name                = "foggykitchen-jump-vm-nsg"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  rules = [
    {
      name                       = "ssh-from-bastion"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefixes    = module.vnet.subnet_address_prefixes["AzureBastionSubnet"]
      destination_address_prefix = "*"
    }
  ]
}
