module "acr" {
  source = "github.com/mlinxfeld/terraform-az-fk-acr"

  acr_name            = var.acr_name
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  sku           = "Basic"
  admin_enabled = false
}
