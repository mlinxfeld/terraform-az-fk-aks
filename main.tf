terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                 = "system"
    vm_size              = var.default_node_vm_size
    node_count           = var.default_node_count
    vnet_subnet_id       = local.effective_subnet_id
    type                 = "VirtualMachineScaleSets"
    orchestrator_version = var.kubernetes_version
  }

  identity {
    type = "SystemAssigned"
  }

  # Calico disabled – network_policy will not be set.
  network_profile {
    network_plugin    = var.network_plugin   # "azure" | "kubenet"
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
    outbound_type     = var.outbound_type # "loadBalancer" | "userDefinedRouting" 
  }

  dynamic "oms_agent" {
   for_each = (var.monitoring_mode == "oms" && local.law_id != null) ? [1] : []
   content {
     log_analytics_workspace_id = local.law_id
   }
  }  

  private_cluster_enabled = var.private_cluster_enabled
  private_dns_zone_id     = var.private_dns_zone_id
  azure_policy_enabled    = false
  oidc_issuer_enabled     = var.oidc_issuer_enabled
  role_based_access_control_enabled = var.rbac_enabled

  tags = local.tags
}

# ACR pull role (opcjonalnie) – przypisujemy do kubelet identity
data "azurerm_role_definition" "acrpull" {
  name = "AcrPull"
  scope = var.acr_id != null ? var.acr_id : null
  count = var.acr_id != null ? 1 : 0
}

resource "azurerm_role_assignment" "acr_pull" {
  count                = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_id   = data.azurerm_role_definition.acrpull[0].role_definition_id
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  depends_on           = [azurerm_kubernetes_cluster.this]
}

data "azurerm_client_config" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

resource "azurerm_role_assignment" "aks_contributor" {
  count             = var.assign_contributor_on_cluster ? 1 : 0
  scope             = azurerm_kubernetes_cluster.this.id
  role_definition_id= data.azurerm_role_definition.contributor.role_definition_id
  principal_id      = data.azurerm_client_config.current.object_id
}

resource "time_sleep" "wait_role" {
  count           = var.assign_contributor_on_cluster ? 1 : 0
  depends_on      = [azurerm_role_assignment.aks_contributor]
  create_duration = "20s"
}