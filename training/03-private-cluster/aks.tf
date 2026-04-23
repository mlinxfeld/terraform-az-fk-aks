module "aks" {
  source              = "../.."
  name                = "fk-aks-private"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  network_plugin = "azure"
  outbound_type  = "userDefinedRouting"
  vnet_id        = module.vnet.vnet_id
  subnet_id      = module.vnet.subnet_ids["foggykitchen-private-subnet"]

  default_node_count      = 2
  default_node_vm_size    = "Standard_D2s_v3"
  private_cluster_enabled = true

  depends_on = [
    module.routing,
    module.natgw
  ]
}
