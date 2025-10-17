module "aks" {
  source              = "../../"
  name                = "fk-aks-acr"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  create_networking = true
  network_plugin    = "kubenet"

  enable_log_analytics = true
  create_law           = true
  monitoring_mode      = "oms"                  
  # assign_contributor_on_cluster = false
}

