# AKS with Terraform/OpenTofu - Training Examples

This directory contains the progressive examples used in the [Azure Kubernetes Service (AKS) with Terraform/OpenTofu - Hands-On Fundamentals (2025 Edition)](https://foggykitchen.com/aks-terraform-course/) course on [FoggyKitchen.com](https://foggykitchen.com).

Each lesson builds on the previous one, moving from a basic Kubenet cluster to private access, registry integration, observability, node pool variants, autoscaling, and persistent storage.

## Disclaimer

Compared with the original course material, this 2026 codebase prefers reusable `terraform-az-fk-*` modules instead of raw resources wherever that makes the architecture clearer and more composable.

---

## Example Overview

| Example | Title | Key Topics |
|---:|---|---|
| 01 | [**Basic Kubenet Cluster**](01-basic-kubenet/) | First AKS cluster using Kubenet networking |
| 02 | [**Azure CNI in Existing VNet**](02-azure-cni-existing-vnet/) | Azure CNI plugin with a custom subnet |
| 03 | [**Private Cluster**](03-private-cluster/) | AKS without a public API endpoint |
| 04 | [**With ACR Attach**](04-with-acr-attach/) | Azure Container Registry integration and workload deployment |
| 05 | [**With Log Analytics**](05-with-log-analytics/) | Log Analytics, AMA, and telemetry verification |
| 06 | [**Additional Node Pools**](06-additional-pools/) | User node pools, labels, and taints |
| 07 | [**Autoscaling**](07-autoscaling/) | Cluster Autoscaler and scale-from-zero validation |
| 08 | [**Persistent Storage**](08-persistent-storage/) | Azure Disk and Azure Files via CSI drivers |

---

## How to Use

Each example directory includes:

- OpenTofu configuration files (`.tf`)
- Kubernetes manifests or generated manifests (`/manifest`, `generated/`)
- Architecture and portal screenshots (`.png`)
- A step-by-step `README.md`

To run a lesson:

```bash
cd training/03-private-cluster
tofu init
tofu apply
```

The lessons can be applied independently, but the recommended approach is sequential:

01 -> 02 -> 03 -> 04 -> 05 -> 06 -> 07 -> 08

## Extra Lessons

Lessons from `09+` are treated as extra material outside the current 2025 course edition.
They are intended as optional extensions and may become part of a future 2026+ edition if that course version is published.

| Extra | Title | Key Topics |
|---:|---|---|
| 09 | [**Private ACR with Private Endpoint**](09-private-acr-with-private-endpoint/) | Private Endpoint, Private DNS, private image-pull path |

---

## Design Principles

- One example equals one architectural goal
- Dependencies stay explicit
- No placeholder infrastructure
- Real workloads and real verification
- The module under test is always the local AKS module, not a hidden copy

The training examples intentionally avoid:

- Full landing zones
- Hidden dependencies between lessons
- Opinionated enterprise wrappers

---

## Related Resources

- [FoggyKitchen AKS Module](../)
- [FoggyKitchen Azure Compute Module](https://github.com/mlinxfeld/terraform-az-fk-compute)
- [FoggyKitchen Azure VNet Module](https://github.com/foggykitchen/terraform-az-fk-vnet)
- [FoggyKitchen Azure ACR Module](https://github.com/mlinxfeld/terraform-az-fk-acr)
- [FoggyKitchen Azure RBAC Module](https://github.com/foggykitchen/terraform-az-fk-rbac)
- [FoggyKitchen Azure Bastion Module](https://github.com/mlinxfeld/terraform-az-fk-bastion)
- [FoggyKitchen Azure NAT Gateway Module](https://github.com/foggykitchen/terraform-az-fk-natgw)
- [FoggyKitchen Azure Routing Module](https://github.com/mlinxfeld/terraform-az-fk-routing)
- [FoggyKitchen Azure Public IP Module](https://github.com/foggykitchen/terraform-az-fk-public-ip)
- [OCI OKE Module](https://github.com/foggykitchen/terraform-oci-fk-oke)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](../LICENSE) for details.
