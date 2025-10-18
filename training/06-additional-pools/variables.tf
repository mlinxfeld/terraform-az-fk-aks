variable "resource_group_name" {
  description = "The name of the Azure Resource Group where resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region (e.g., East US, West Europe)"
  type        = string
}

variable "additional_node_pools" {
  description = "Additional Node Pool definition"
  default = [
    {
      name                 = "userpool"
      vm_size              = "Standard_D2s_v3"
      node_count           = 0  # Autoscaller                
      mode                 = "User"
      orchestrator_version = null
      subnet_id            = null                  
      taints               = ["dedicated=user:NoSchedule"]
      labels               = { workload = "apps", sku = "general" }
      max_pods             = 30
      enable_auto_scaling  = true
      min_count            = 1
      max_count            = 3
      spot                 = false
    }
  ]
}