module "aks" {
  source              = "../../"
  name                = "fk-aks-autoscale"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  create_networking = true
  network_plugin    = "kubenet"

  additional_node_pools = var.additional_node_pools
}

