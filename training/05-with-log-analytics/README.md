# Lesson 05 – AKS with Log Analytics (OMS Monitoring)

In this example, we extend our Azure Kubernetes Service (AKS) deployment with **Azure Monitor for Containers** using the **OMS (Log Analytics) add-on**.  
This integration automatically collects performance metrics and container logs from the AKS cluster into an Azure Log Analytics Workspace (LAW).

📘 Related blog post:
[AKS Log Analytics with Terraform — How the FoggyKitchen Module Automates Azure Monitor Integration](https://foggykitchen.com/2025/11/24/aks-log-analytics-terraform/)

---

## 📘 Overview

In previous examples, we focused on AKS fundamentals (Kubenet, ACR integration, private clusters).  
Now, we’ll add centralized **monitoring and observability** capabilities using **Azure Monitor**.  
The deployment will create:
- An **AKS cluster** (system-assigned identity).
- A **Log Analytics Workspace (LAW)**.
- The **OMS agent add-on** enabled on the cluster for log collection.

---

## 🧱 Terraform Configuration Highlights

- `azurerm_log_analytics_workspace` – creates the workspace for logs and metrics.
- `azurerm_kubernetes_cluster` → `oms_agent` block – connects AKS with LAW.
- Logs and metrics will be visible in Azure Portal → **AKS → Insights** and **LAW → Logs**.

Example snippet from module:

```hcl
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name

  default_node_pool {
    name       = "system"
    vm_size    = "Standard_D2s_v3"
    node_count = 1
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
    service_cidr      = "10.200.0.0/16"
    dns_service_ip    = "10.200.0.10"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }
}
```

---

## 🔍 Where to See OMS in Azure Portal

Once deployed, your monitoring data becomes available across multiple Azure views:

### **1️⃣ AKS → Insights**
Navigate to:
```
Azure Portal → AKS Cluster → Insights
```
View metrics for **Nodes**, **Controllers**, and **Containers**.

### **2️⃣ Log Analytics Workspace → Logs**
```
Azure Portal → Log Analytics Workspace → Logs
```
Run KQL queries such as:
```kusto
ContainerLog | take 20
```
You can explore tables like:
- `ContainerLog`
- `KubePodInventory`
- `InsightsMetrics`
- `Perf`

### **3️⃣ AKS → Properties → Monitoring**
Shows the linked Log Analytics Workspace ID.

### **4️⃣ CLI verification**
```bash
az aks show -g fk-aks-demo-rg -n fk-aks-monitor --query addonProfiles.omsagent
```

---

## 🖼️ Azure Portal View

<img src="05-with-log-analytics.png" width="900"/>

Example of container logs from Log Analytics Workspace (LAW).

---

## 🌐 Learn More

Visit [FoggyKitchen.com](https://foggykitchen.com/) for more hybrid cloud examples, architecture diagrams, and in-depth learning.

---

## 🪪 License

Licensed under the Universal Permissive License (UPL), Version 1.0.  
See [LICENSE](../../LICENSE) for more details.
