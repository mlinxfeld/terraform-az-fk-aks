resource "azurerm_log_analytics_workspace" "law" {
  count               = var.enable_log_analytics && var.create_law ? 1 : 0
  name                = "${var.name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.law_sku
  retention_in_days   = var.law_retention_days
  tags                = local.tags
}

locals {
  law_id = var.enable_log_analytics ? coalesce(
    var.log_analytics_workspace_id,
    try(azurerm_log_analytics_workspace.law[0].id, null)
  ) : null
}

resource "azurerm_kubernetes_cluster_extension" "ama" {
  count           = (var.monitoring_mode == "ama" && local.law_id != null) ? 1 : 0
  name            = "azuremonitor-containers"
  cluster_id      = azurerm_kubernetes_cluster.this.id
  extension_type  = "microsoft.azuremonitor.containers"
  release_train   = "Stable"
  configuration_settings = {
    logAnalyticsWorkspaceResourceID = local.law_id
  }
  depends_on = [
    azurerm_kubernetes_cluster.this,
    time_sleep.wait_role
  ]
}