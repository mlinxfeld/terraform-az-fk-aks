resource "azurerm_container_registry" "fk-acr1" {
  name                = "fkacr1"
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  location            = azurerm_resource_group.foggykitchen_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "fk-acr1_pull" {
  scope                = azurerm_container_registry.fk-acr1.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_object_id   
  depends_on           = [module.aks]
}