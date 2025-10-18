# AKS with Terraform/OpenTofu – Training Modules

This directory contains all examples used in the **Azure Kubernetes Service (AKS) with Terraform/OpenTofu – Hands-On Fundamentals (2025 Edition)** course on [FoggyKitchen.com](https://foggykitchen.com).

Each lesson builds upon the previous one — from the simplest Kubenet cluster to observability, autoscaling, and persistent storage.

---

## 🧭 Module Overview

| Module | Title | Key Topics |
|:-------|:-------|:------------|
| 01 | **Basic Kubenet Cluster** | First AKS cluster using the default Kubenet networking |
| 02 | **Azure CNI in Existing VNet** | Switch to Azure CNI plugin and use a custom subnet |
| 03 | **Private Cluster** | Deploy AKS without a public API endpoint |
| 04 | **With ACR Attach** | Integrate Azure Container Registry and deploy workloads |
| 05 | **With Log Analytics** | Enable monitoring with Log Analytics + AMA |
| 06 | **Additional Node Pools** | Add user-defined pools for workloads |
| 07 | **Autoscaling** | Configure Cluster Autoscaler and validate scale-up/down |
| 08 | **Persistent Storage** | Use Azure Disk and Azure Files dynamically provisioned by AKS |

---

## ⚙️ How to Use

Each lesson includes:
- Terraform/OpenTofu code (`.tf`)
- Kubernetes manifests (`/manifest`)
- Azure Portal screenshot (`.png`)
- Step-by-step guide (`README.md`)

To run any lesson:

```bash
cd training/03-private-cluster
tofu init
tofu apply
```

Each directory can be applied independently, but the recommended way is to go **sequentially**, as each lesson builds on the previous one.

---

## 🧩 Related Resources

- [FoggyKitchen AKS Module (terraform-az-fk-aks)](../)
- [OCI OKE Module (terraform-oci-fk-oke)](https://github.com/mlinxfeld/terraform-oci-fk-oke)
- [Multicloud Foundations: Azure & OCI deployed with Terraform/OpenTofu](https://foggykitchen.com/courses/multicloud-foundations-azure-oci-terraform-opentofu/)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](../LICENSE) for details.

---

© 2025 [FoggyKitchen.com](https://foggykitchen.com) — *Cloud. Code. Clarity.*

