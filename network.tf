resource "azurerm_virtual_network" "vnet" {
  count               = var.create_networking ? 1 : 0
  name                = "${var.name}-vnet"
  address_space       = var.vnet_cidr
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_subnet" "aks" {
  count                = var.create_networking ? 1 : 0
  name                 = "${var.name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  address_prefixes     = var.subnet_cidr
}

locals {
  effective_subnet_id   = coalesce(var.subnet_id, try(azurerm_subnet.aks[0].id, null))
  effective_vnet_id     = coalesce(var.vnet_id,   try(azurerm_virtual_network.vnet[0].id, null))
  effective_subnet_name = coalesce(var.subnet_id, try(azurerm_subnet.aks[0].name, null))
  effective_vnet_name   = coalesce(var.vnet_id,   try(azurerm_virtual_network.vnet[0].name, null))
}