resource "azurerm_container_registry" "this" {
  count               = var.create_acr ? 1 : 0
  name                = var.acr_name
  resource_group_name = local.effective_resource_group_name
  location            = local.effective_location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = local.tags
}

locals {
  effective_acr_id           = var.acr_id != null ? var.acr_id : try(azurerm_container_registry.this[0].id, null)
  effective_acr_name         = try(azurerm_container_registry.this[0].name, null)
  effective_acr_login_server = try(azurerm_container_registry.this[0].login_server, null)
}
