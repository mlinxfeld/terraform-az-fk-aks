module "aks" {
  source              = "github.com/mlinxfeld/terraform-az-fk-aks"
  name                = "fk-aks-cni"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  network_plugin = "azure"
  vnet_id        = azurerm_virtual_network.foggykitchen_vnet.id
  subnet_id      = azurerm_subnet.foggykitchen_public_subnet.id

  default_node_count   = 2
  default_node_vm_size = "Standard_D2s_v3" 
}
