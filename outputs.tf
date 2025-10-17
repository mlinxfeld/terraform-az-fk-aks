output "cluster_id" { 
    value = azurerm_kubernetes_cluster.this.id 
}

output "cluster_name" { 
    value = azurerm_kubernetes_cluster.this.name 
}

output "node_resource_group" { 
    value = azurerm_kubernetes_cluster.this.node_resource_group 
}

output "fqdn" { 
    value = azurerm_kubernetes_cluster.this.fqdn 
}

output "private_fqdn" { 
    value = azurerm_kubernetes_cluster.this.private_fqdn 
}

output "vnet_id" { 
    value = local.effective_vnet_id 
}

output "subnet_id" { 
    value = local.effective_subnet_id 
}

output "vnet_name" { 
    value = local.effective_vnet_name 
}

output "subnet_name" { 
    value = local.effective_subnet_name 
}

output "kubeconfig_raw" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "kubelet_object_id" { 
   value = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id 
}
