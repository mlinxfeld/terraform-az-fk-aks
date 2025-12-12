# Lesson 2: AKS Cluster with Azure CNI (Advanced Networking)

In this example, we’ll deploy an AKS cluster using **Azure CNI** networking instead of Kubenet.
Pods will receive IP addresses directly from the Virtual Network, enabling full integration with Azure services.

📘 Related blog post:
[Kubenet vs Azure CNI in AKS – What’s the Difference (with Terraform examples](https://foggykitchen.com/2025/11/14/aks-kubenet-vs-azure-cni/)

---

## 🧭 Architecture Overview

This scenario builds upon Lesson 1 and introduces:
- A pre-created Virtual Network and Subnet for AKS nodes and pods.
- An AKS Cluster configured with `network_plugin = "azure"`.
- Optional NSG rules for controlled traffic flow.

> Using Azure CNI allows pod-to-VM communication without NAT — useful for enterprise networking and hybrid connectivity scenarios.

---

## 🚀 Deployment Steps

```bash
tofu init
tofu plan
tofu apply
```

Fetch credentials and verify cluster readiness:

```bash
mlinxfeld@Martins-MacBook-Pro 01-azure-cni-existing-vnet % az aks get-credentials -g fk-aks-demo-rg -n fk-aks-cni
Merged "fk-aks-cni" as current context in /Users/mlinxfeld/.kube/config

mlinxfeld@Martins-MacBook-Pro 01-azure-cni-existing-vnet % kubectl get nodes
NAME                             STATUS   ROLES    AGE     VERSION
aks-system-16105998-vmss000000   Ready    <none>   9m10s   v1.31.10
aks-system-16105998-vmss000001   Ready    <none>   9m13s   v1.31.10

mlinxfeld@Martins-MacBook-Pro 01-azure-cni-existing-vnet % kubectl get pods -A -o wide
NAMESPACE     NAME                                            READY   STATUS    RESTARTS   AGE     IP          NODE                             NOMINATED NODE   READINESS GATES
kube-system   azure-ip-masq-agent-fdvgq                       1/1     Running   0          9m22s   10.0.1.33   aks-system-16105998-vmss000001   <none>           <none>
kube-system   azure-ip-masq-agent-z5kpg                       1/1     Running   0          9m19s   10.0.1.4    aks-system-16105998-vmss000000   <none>           <none>
kube-system   cloud-node-manager-b8zwp                        1/1     Running   0          9m22s   10.0.1.33   aks-system-16105998-vmss000001   <none>           <none>
kube-system   cloud-node-manager-slhhm                        1/1     Running   0          9m19s   10.0.1.4    aks-system-16105998-vmss000000   <none>           <none>
kube-system   coredns-789465848c-ng229                        1/1     Running   0          8m55s   10.0.1.16   aks-system-16105998-vmss000000   <none>           <none>
kube-system   coredns-789465848c-xtzdt                        1/1     Running   0          10m     10.0.1.39   aks-system-16105998-vmss000001   <none>           <none>
kube-system   coredns-autoscaler-55bcd876cc-5xbp7             1/1     Running   0          10m     10.0.1.41   aks-system-16105998-vmss000001   <none>           <none>
kube-system   csi-azuredisk-node-dzdt9                        3/3     Running   0          9m19s   10.0.1.4    aks-system-16105998-vmss000000   <none>           <none>
kube-system   csi-azuredisk-node-hfgln                        3/3     Running   0          9m22s   10.0.1.33   aks-system-16105998-vmss000001   <none>           <none>
kube-system   csi-azurefile-node-2r7df                        3/3     Running   0          9m22s   10.0.1.33   aks-system-16105998-vmss000001   <none>           <none>
kube-system   csi-azurefile-node-xxczm                        3/3     Running   0          9m19s   10.0.1.4    aks-system-16105998-vmss000000   <none>           <none>
kube-system   konnectivity-agent-8cc55cdb8-j68ds              1/1     Running   0          10m     10.0.1.56   aks-system-16105998-vmss000001   <none>           <none>
kube-system   konnectivity-agent-8cc55cdb8-k9b99              1/1     Running   0          8m55s   10.0.1.18   aks-system-16105998-vmss000000   <none>           <none>
kube-system   konnectivity-agent-autoscaler-679b77b4f-xx76r   1/1     Running   0          10m     10.0.1.35   aks-system-16105998-vmss000001   <none>           <none>
kube-system   kube-proxy-6prcr                                1/1     Running   0          9m22s   10.0.1.33   aks-system-16105998-vmss000001   <none>           <none>
kube-system   kube-proxy-6pzzb                                1/1     Running   0          9m19s   10.0.1.4    aks-system-16105998-vmss000000   <none>           <none>
kube-system   metrics-server-5c7b55fddd-8lbzj                 2/2     Running   0          8m37s   10.0.1.27   aks-system-16105998-vmss000000   <none>           <none>
kube-system   metrics-server-5c7b55fddd-vd8w4                 2/2     Running   0          8m37s   10.0.1.20   aks-system-16105998-vmss000000   <none>           <none>
```

Observe how pods now receive **IP addresses from the VNet subnet**.

---

## 🖼️ Azure Portal View

<img src="02-azure-cni-existing-vnet.png" width="900"/>

You’ll see the cluster’s Virtual Network integration under **Networking → Network configuration**.

---

## 🧹 Cleanup

```bash
tofu destroy
```

---

### ✅ Summary

This example shows how to:
- Use **Azure CNI** for full IP-level connectivity between pods and Azure resources.
- Plan subnet CIDR blocks carefully for large clusters.
- Compare Kubenet (Lesson 1) vs Azure CNI (Lesson 2).

Azure CNI mode is equivalent to the **Enhanced (VCN-Native)** cluster mode in OCI OKE.

---

## 🌐 Learn More

Visit [FoggyKitchen.com](https://foggykitchen.com/) for hybrid cloud examples, architecture diagrams, and in-depth learning.

---

## 🪪 License

Licensed under the Universal Permissive License (UPL), Version 1.0.  
See [LICENSE](../../LICENSE) for more details.
