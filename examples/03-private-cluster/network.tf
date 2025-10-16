resource "azurerm_virtual_network" "foggykitchen_vnet" {
  name                = "foggykitchen-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
}

resource "azurerm_subnet" "foggykitchen_private_subnet" {
  name                 = "foggykitchen_private_subnet"
  resource_group_name  = azurerm_resource_group.foggykitchen_rg.name
  virtual_network_name = azurerm_virtual_network.foggykitchen_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
