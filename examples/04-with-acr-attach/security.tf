resource "azurerm_network_security_group" "agents" {
  name                = "fk-aks-agents-nsg"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "agents_assoc" {
  subnet_id                 = module.aks.subnet_id
  network_security_group_id = azurerm_network_security_group.agents.id
}

resource "azurerm_network_security_rule" "allow_lb_probes" {
  name                        = "allow-azlb-probes-nodeport"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  destination_port_ranges     = ["30000-32767"]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.agents.name
}

resource "azurerm_network_security_rule" "allow_http_nodeport" {
  name                        = "allow-http-nodeport"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"        
  destination_address_prefix  = "*"
  destination_port_range      = "32209"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.agents.name
}

resource "azurerm_network_security_rule" "allow_http_80" {
  name                        = "allow-http-80"
  priority                    = 205
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"          
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.agents.name
}