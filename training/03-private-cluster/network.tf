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

resource "azurerm_route_table" "foggykitchen_aks_udr" {
  name                = "foggykitchen_aks_udr"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
}

resource "azurerm_subnet_route_table_association" "foggykitchen_aks_udr_assoc" {
  subnet_id      = azurerm_subnet.foggykitchen_private_subnet.id
  route_table_id = azurerm_route_table.foggykitchen_aks_udr.id
}

resource "azurerm_subnet" "foggykitchen_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.foggykitchen_rg.name
  virtual_network_name = azurerm_virtual_network.foggykitchen_vnet.name
  address_prefixes     = ["10.0.2.0/26"]
}

resource "azurerm_public_ip" "foggykitchen_bastion_public_ip" {
  name                = "foggykitchen_bastion_public_ip"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "foggykitchen_nat_gw" {
  name                = "foggykitchen_nat_gw"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  sku_name            = "Standard"
}

resource "azurerm_public_ip" "foggykitchen_natgw_public_ip" {
  name                = "foggykitchen_natgw_ip"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "foggykitchen_natgw_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.foggykitchen_nat_gw.id
  public_ip_address_id = azurerm_public_ip.foggykitchen_natgw_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "private_nat_assoc" {
  subnet_id      = azurerm_subnet.foggykitchen_private_subnet.id
  nat_gateway_id = azurerm_nat_gateway.foggykitchen_nat_gw.id
}

resource "azurerm_network_interface" "foggykitchen_jump_vm_nic" {
  name                = "fkjumpvm-nic"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.foggykitchen_private_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}