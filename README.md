# terraform-az-fk-aks

This repository contains a reusable **OpenTofu module** and progressive training examples for deploying **Azure Kubernetes Service (AKS)** clusters.

It is part of the [FoggyKitchen.com](https://foggykitchen.com) training ecosystem and is designed as a composable AKS layer that can be combined with networking, registry, observability, and workload modules.

---

## Purpose

The goal of this module is to provide a clear, architecture-aware reference implementation for AKS:

- AKS cluster provisioning
- System and user node pools
- Optional VNet and subnet creation
- Optional private cluster mode
- Optional Azure Container Registry attachment
- Optional Log Analytics integration
- Optional additional node pools and autoscaling
- Optional OIDC and RBAC settings

This is not a full landing zone or opinionated platform module. It is a learning-first module that keeps dependencies explicit.

---

## What the module does

Depending on the configuration, the module can create:

- Azure Kubernetes Service cluster
- Default system node pool
- Optional additional user node pools
- Optional VNet and subnet
- Optional ACR role assignment
- Optional Log Analytics Workspace integration
- Optional RBAC and OIDC settings

The module intentionally does not create:

- Application workloads
- Persistent volume manifests
- Bastion hosts
- NAT Gateway
- NSGs
- External monitoring backends outside the module API

Those concerns belong in their own dedicated modules or example-specific resources.

---

## Repository Structure

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
├── main.tf
├── network.tf
├── node_pools.tf
├── diagnostics.tf
├── locals.tf
├── outputs.tf
├── variables.tf
├── LICENSE
└── README.md
```

All examples from the FoggyKitchen AKS course are located under [`training/`](training).

---

## Example Usage

```hcl
module "aks" {
  source = "git::https://github.com/mlinxfeld/terraform-az-fk-aks.git?ref=v0.1.0"

  name                = "fk-aks-demo"
  location            = "westeurope"
  create_rg           = true
  resource_group_name = "fk-aks-demo-rg"

  create_networking = true
  vnet_cidr         = ["10.10.0.0/16"]
  subnet_cidr       = ["10.10.1.0/24"]
  network_plugin    = "azure"
  service_cidr      = "10.200.0.0/16"
  dns_service_ip    = "10.200.0.10"

  default_node_vm_size = "Standard_D2s_v3"
  default_node_count    = 1

  additional_node_pools = [
    {
      name                = "userpool"
      vm_size             = "Standard_D2s_v3"
      node_count          = 0
      mode                = "User"
      taints              = ["dedicated=user:NoSchedule"]
      labels              = { workload = "apps", sku = "general" }
      max_pods            = 30
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3
      spot                = false
    }
  ]

  acr_id = "/subscriptions/<sub_id>/resourceGroups/fk-aks-demo-rg/providers/Microsoft.ContainerRegistry/registries/fkacr1"

  enable_log_analytics   = true
  create_law             = true
  law_sku                = "PerGB2018"
  law_retention_days     = 30
  monitoring_mode        = "oms"

  rbac_enabled         = true
  oidc_issuer_enabled  = true

  tags = {
    project = "foggykitchen-aks"
    owner   = "mlinxfeld"
  }
}
```

---

## Inputs

| Variable | Type | Default | Description |
|---|---|---:|---|
| `name` | string | `foggykitchen-aks` | AKS cluster name |
| `location` | string | n/a | Azure region |
| `create_rg` | bool | `false` | Create a new resource group |
| `resource_group_name` | string | `""` | Existing resource group name |
| `kubernetes_version` | string | `""` | AKS version |
| `create_networking` | bool | `false` | Create VNet and subnet |
| `vnet_cidr` | list(string) | `["10.10.0.0/16"]` | VNet CIDR |
| `subnet_cidr` | list(string) | `["10.10.1.0/24"]` | Subnet CIDR |
| `network_plugin` | string | `azure` | `azure` or `kubenet` |
| `service_cidr` | string | `10.200.0.0/16` | Service CIDR |
| `dns_service_ip` | string | `10.200.0.10` | DNS service IP |
| `private_cluster_enabled` | bool | `false` | Enable private cluster mode |
| `default_node_count` | number | `1` | Default system node count |
| `default_node_vm_size` | string | `Standard_D2s_v3` | Default node VM size |
| `additional_node_pools` | list(object) | `[]` | Additional node pool definitions |
| `acr_id` | string | `null` | Optional ACR ID to attach |
| `enable_log_analytics` | bool | `false` | Enable Log Analytics integration |
| `log_analytics_workspace_id` | string | `null` | Existing Log Analytics Workspace ID |
| `create_law` | bool | `false` | Create a new Log Analytics Workspace |
| `law_sku` | string | `PerGB2018` | Log Analytics SKU |
| `law_retention_days` | number | `30` | Log retention days |
| `monitoring_mode` | string | `oms` | Monitoring mode |
| `rbac_enabled` | bool | `true` | Enable AKS RBAC |
| `oidc_issuer_enabled` | bool | `true` | Enable OIDC issuer |
| `assign_contributor_on_cluster` | bool | `false` | Optional contributor fallback |
| `tags` | map(string) | `{}` | Resource tags |

---

## Outputs

| Output | Description |
|---|---|
| `cluster_id` | AKS resource ID |
| `cluster_name` | AKS cluster name |
| `node_resource_group` | Managed node resource group |
| `resource_group_name` | Effective resource group name |
| `location` | Effective Azure region |
| `fqdn` | Public cluster FQDN |
| `private_fqdn` | Private cluster FQDN when enabled |
| `vnet_id` | Effective VNet ID |
| `subnet_id` | Effective subnet ID |
| `vnet_name` | Effective VNet name |
| `subnet_name` | Effective subnet name |
| `kubeconfig_raw` | Sensitive raw kubeconfig |
| `kubelet_object_id` | Object ID of the kubelet identity |
| `acr_id` | Effective ACR ID |
| `acr_name` | Effective ACR name |
| `acr_login_server` | Effective ACR login server |
| `log_analytics_workspace_id` | Log Analytics Workspace ID |
| `log_analytics_workspace_name` | Workspace name when created by the module |

---

## Design Principles

- AKS stays a reusable module, not a full platform wrapper
- Networking, registry, observability, and workload concerns stay explicit
- Training examples build on one another, but each example remains runnable on its own
- Outputs are first-class values, because downstream modules need them

---

## Related Resources

- [Training examples](training)
- [FoggyKitchen Azure Compute Module](https://github.com/mlinxfeld/terraform-az-fk-compute)
- [FoggyKitchen Azure VNet Module](https://github.com/mlinxfeld/terraform-az-fk-vnet)
- [FoggyKitchen Azure ACR Module](https://github.com/mlinxfeld/terraform-az-fk-acr)
- [FoggyKitchen Azure RBAC Module](https://github.com/mlinxfeld/terraform-az-fk-rbac)
- [FoggyKitchen Azure Bastion Module](https://github.com/mlinxfeld/terraform-az-fk-bastion)
- [FoggyKitchen Azure NAT Gateway Module](https://github.com/mlinxfeld/terraform-az-fk-natgw)
- [FoggyKitchen Azure Routing Module](https://github.com/mlinxfeld/terraform-az-fk-routing)
- [FoggyKitchen Azure Public IP Module](https://github.com/mlinxfeld/terraform-az-fk-public-ip)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](LICENSE) for details.
