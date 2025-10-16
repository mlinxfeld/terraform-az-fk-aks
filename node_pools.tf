resource "azurerm_kubernetes_cluster_node_pool" "extra" {
  for_each              = { for np in var.additional_node_pools : np.name => np }
  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  mode                  = each.value.mode
  vnet_subnet_id        = try(each.value.subnet_id, null)
  orchestrator_version  = try(each.value.orchestrator_version, null)
  enable_auto_scaling   = each.value.enable_auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  node_labels           = try(each.value.labels, null)
  node_taints           = try(each.value.taints, null)
  max_pods              = try(each.value.max_pods, null)
  priority              = each.value.spot ? "Spot" : "Regular"
}