resource "azurerm_resource_group" "this" {
  count    = var.create_rg ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

locals {
  effective_resource_group_name = var.create_rg ? azurerm_resource_group.this[0].name : var.resource_group_name
  effective_location            = var.create_rg ? azurerm_resource_group.this[0].location : var.location
}
