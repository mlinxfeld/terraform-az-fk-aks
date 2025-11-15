module "aks" {
  source              = "github.com/mlinxfeld/terraform-az-fk-aks"
  name                = "fk-aks-private"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  network_plugin = "azure"
  outbound_type  = "userDefinedRouting"
  vnet_id        = azurerm_virtual_network.foggykitchen_vnet.id
  subnet_id      = azurerm_subnet.foggykitchen_private_subnet.id

  default_node_count   = 2
  default_node_vm_size = "Standard_D2s_v3" 
  private_cluster_enabled = true

  depends_on = [ 
    azurerm_route_table.foggykitchen_aks_udr,
    azurerm_subnet_route_table_association.foggykitchen_aks_udr_assoc
  ]
}
