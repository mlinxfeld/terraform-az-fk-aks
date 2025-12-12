# Lesson 1: Basic AKS Cluster (Kubenet Networking)

In this first example, we’ll deploy a simple **Azure Kubernetes Service (AKS)** cluster using **Kubenet** networking.
All resources are created from scratch — Resource Group, Virtual Network, Subnet, and AKS Cluster — making this a perfect starting point for anyone new to AKS or Terraform on Azure.

📘 Related blog post:
[Kubenet vs Azure CNI in AKS – What’s the Difference (with Terraform examples](https://foggykitchen.com/2025/11/14/aks-kubenet-vs-azure-cni/)

---

## 🧭 Architecture Overview

This deployment creates:
- A new **Resource Group** for AKS.
- A **Virtual Network** with a single subnet for AKS nodes.
- An **AKS Cluster** with default node pool (2 nodes, Kubenet plugin).
- SSH access enabled for management.

> AKS Control Plane is public in this example, meaning you can interact with the cluster directly from your workstation.

---

## 🚀 Deployment Steps

Initialize and apply Terraform configuration:

```bash
tofu init
tofu plan
tofu apply
```

After the cluster is ready, fetch credentials and verify connectivity:

```bash
mlinxfeld@Martins-MacBook-Pro 01-basic-kubenet % az aks get-credentials -g fk-aks-demo-rg -n fk-aks-demo
Merged "fk-aks-demo" as current context in /Users/mlinxfeld/.kube/config

mlinxfeld@Martins-MacBook-Pro 01-basic-kubenet % kubectl get nodes
NAME                             STATUS   ROLES    AGE     VERSION
aks-system-37715129-vmss000000   Ready    <none>   4m27s   v1.31.10
```

---

## 🖼️ Azure Portal View

Below you can see the resulting Kubenet-based AKS cluster in the Azure Portal:

<img src="01-basic-kubenet.png" width="900"/>

---

## 🧹 Cleanup

To remove all resources created by this example:

```bash
tofu destroy
```

---

### ✅ Summary

This example demonstrates:
- Provisioning a **basic AKS cluster** with Kubenet networking.
- How Azure automatically handles routing between pods and nodes.
- How to connect to the cluster directly from your workstation.

---

## 🌐 Learn More

Visit [FoggyKitchen.com](https://foggykitchen.com/) for hybrid cloud examples, architecture diagrams, and in-depth learning.

---

## 🪪 License

Licensed under the Universal Permissive License (UPL), Version 1.0.  
See [LICENSE](../../LICENSE) for more details.
