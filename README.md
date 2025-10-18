# Terraform-AZ-FK-AKS

This repository contains a reusable Terraform module and complete training examples for deploying **Azure Kubernetes Service (AKS)** clusters with **Terraform/OpenTofu**.  
It’s part of the [FoggyKitchen.com](https://foggykitchen.com) training series:  
🧩 *Azure Kubernetes Service (AKS) with Terraform/OpenTofu – Hands-On Fundamentals (2025 Edition).*

The module automates:
- AKS cluster provisioning (System & User node pools)  
- Optional network creation (VNet, Subnets)  
- ACR (Azure Container Registry) attachment  
- Log Analytics / AMA integration  
- RBAC & OIDC enablement  
- Autoscaling and tagging  

---

## 📂 Repository Structure

```bash
terraform-az-fk-aks/
├── training/
│   ├── 01-basic-kubenet/
│   ├── 02-azure-cni-existing-vnet/
│   ├── 03-private-cluster/
│   ├── 04-with-acr-attach/
│   ├── 05-with-log-analytics/
│   ├── 06-additional-pools/
│   ├── 07-autoscaling/
│   ├── 08-persistent-storage/
│   └── README.md
(...)
├── LICENSE
└── README.md
```

All examples from the FoggyKitchen AKS course are located under the [`training/`](training) directory.

---

## 🚀 Example Usage

```hcl
module "aks" {
  source              = "../.."  # path to the module
  name                = "fk-aks-demo"
  location            = "westeurope"
  create_rg           = true
  resource_group_name = "fk-aks-demo-rg"

  # Networking
  create_networking   = true
  vnet_cidr           = ["10.10.0.0/16"]
  subnet_cidr         = ["10.10.1.0/24"]
  network_plugin      = "azure"
  service_cidr        = "10.200.0.0/16"
  dns_service_ip      = "10.200.0.10"

  # Default Node Pool
  default_node_vm_size  = "Standard_D2s_v3"
  default_node_count    = 1

  # Additional Node Pools
  additional_node_pools = [
    {
      name                 = "userpool"
      vm_size              = "Standard_D2s_v3"
      node_count           = 0
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

  # ACR attach (optional)
  acr_id = "/subscriptions/<sub_id>/resourceGroups/fk-aks-demo-rg/providers/Microsoft.ContainerRegistry/registries/fkacr1"

  # Observability (optional)
  enable_log_analytics      = true
  create_law                = true
  law_sku                   = "PerGB2018"
  law_retention_days        = 30
  monitoring_mode           = "ama"

  # RBAC / Auth
  rbac_enabled          = true
  oidc_issuer_enabled   = true

  tags = {
    project = "foggykitchen-aks"
    owner   = "mlinxfeld"
  }
}
```

---

## ⚙️ Module Inputs

| Variable | Type | Default | Description |
|-----------|------|----------|-------------|
| `name` | string | `"foggykitchen-aks"` | AKS cluster name |
| `location` | string | `""` | Azure region |
| `create_rg` | bool | `false` | Create new Resource Group |
| `resource_group_name` | string | `""` | Existing RG (used if `create_rg=false`) |
| `kubernetes_version` | string | `"1.31.10"` | AKS version |
| `vnet_id` | string | `null` | Existing VNet ID |
| `subnet_id` | string | `null` | Existing Subnet ID |
| `create_networking` | bool | `false` | Create new VNet/Subnet |
| `vnet_cidr` | list(string) | `["10.10.0.0/16"]` | VNet CIDR |
| `subnet_cidr` | list(string) | `["10.10.1.0/24"]` | Subnet CIDR |
| `network_plugin` | string | `"azure"` | `azure` or `kubenet` |
| `service_cidr` | string | `"10.200.0.0/16"` | Service CIDR |
| `dns_service_ip` | string | `"10.200.0.10"` | DNS service IP |
| `network_policy` | string | `null` | Network policy (Azure / Calico) |
| `private_cluster_enabled` | bool | `false` | Enable private cluster |
| `private_dns_zone_id` | string | `null` | For private clusters |
| `default_node_count` | number | `1` | Default system node count |
| `default_node_vm_size` | string | `"Standard_D2s_v3"` | Default node VM size |
| `default_node_subnet_id` | string | `null` | Custom subnet for default pool |
| `additional_node_pools` | list(object) | `[]` | List of additional pools (see example) |
| `acr_id` | string | `null` | Optional ACR ID to attach |
| `enable_log_analytics` | bool | `false` | Enable Log Analytics integration |
| `log_analytics_workspace_id` | string | `null` | Existing Log Analytics Workspace ID |
| `create_law` | bool | `false` | Create new Log Analytics Workspace |
| `law_sku` | string | `"PerGB2018"` | SKU for Log Analytics |
| `law_retention_days` | number | `30` | Log retention days |
| `monitoring_mode` | string | `"oms"` | Monitoring type (`oms` or `ama`) |
| `assign_contributor_on_cluster` | bool | `false` | Assign Contributor when lacking privileges |
| `rbac_enabled` | bool | `true` | Enable RBAC |
| `oidc_issuer_enabled` | bool | `true` | Enable OIDC issuer |
| `aks_version` | string | `null` | If null → latest available version |
| `tags` | map(string) | `{}` | Custom tags |

---

## 📤 Outputs

| Output | Description |
|---------|-------------|
| `cluster_id` | Full AKS resource ID |
| `kube_config` | Base64 kubeconfig for kubectl |
| `kubelet_identity` | Managed identity for node pool |
| `law_id` | Log Analytics Workspace ID (if created) |
| `acr_role_assignment_id` | ID of ACR Pull role assignment |

---

## 🧩 Related Examples

Each example from the FoggyKitchen AKS course uses this module:  
[See the `training/` folder](training)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](LICENSE) for details.

---

© 2025 [FoggyKitchen.com](https://foggykitchen.com) — *Cloud. Code. Clarity.*

