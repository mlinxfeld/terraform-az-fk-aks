# Basics
variable "name" { 
    type    = string # for example foggykitchen-aks
    default = "foggykitchen-aks"
}                  

variable "location" { 
    type = string 
    default = ""
}

variable "create_rg" { 
    type = bool   
    default = false 
}

variable "resource_group_name" { 
    type = string 
    default = "" # existing RG (albo create_rg = true)
}                  

variable "kubernetes_version" {
    type = string 
    default = "1.31.10" 
}

# Networking
variable "vnet_id" { 
    type = string  
    default = null 
}

variable "subnet_id" { 
    type = string  
    default = null 
}

variable "create_networking" { 
    type = bool    
    default = false 
}

variable "vnet_cidr" { 
    type = list(string) 
    default = ["10.10.0.0/16"] 
}

variable "subnet_cidr" { 
    type = list(string) 
    default = ["10.10.1.0/24"] 
}

variable "network_plugin" { 
    type = string  
    default = "azure" # "azure" | "kubenet"
}   

variable "service_cidr" {
    type = string
    default = "10.200.0.0/16"
}

variable "dns_service_ip" {
    type = string
    default = "10.200.0.10"
}

variable "network_policy" { 
    type = string  
    default = null # null | "azure" | "calico"
}      

variable "private_cluster_enabled" { 
    type = bool   
    default = false 
}

variable "private_dns_zone_id" { 
    type = string  
    default = null  # for private cluster
}     

variable "outbound_type" {
    type = string  
    default = "loadBalancer"  # for private cluster
}

# Node pool (default)
variable "default_node_count" { 
    type = number  
    default = 1 
}
variable "default_node_vm_size" { 
    type = string  
    default = "Standard_D2s_v3" 
}
variable "default_node_subnet_id" { 
    type = string 
    default = null # override when many subnets
}      

# Additional Pools
variable "additional_node_pools" {
  description = "List of additional pools"
  type = list(object({
    name                = string
    vm_size             = string
    node_count          = number
    mode                = string    # "User" | "System"
    orchestrator_version= string    # optional
    subnet_id           = string    # optional
    taints              = list(string)
    labels              = map(string)
    max_pods            = number    # useful Kubenet/CNI
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    spot                = bool
  }))
  default = []
}

# ACR attach (optional)
variable "acr_id" { 
    type = string  
    default = null 
}

# Diagnostics
variable "enable_log_analytics" { 
    type = bool    
    default = false 
}
variable "log_analytics_workspace_id" { 
    type = string 
    default = null 
}
variable "create_law" { 
    type = bool    
    default = false 
}
variable "law_sku" {
    type = string  
    default = "PerGB2018" 
}
variable "law_retention_days" { 
    type = number  
    default = 30 
}

variable "monitoring_mode" { 
    type = string 
    default = "oms" # "oms" | "ama"
}  

variable "assign_contributor_on_cluster" { 
    type = bool 
    default = false # only for AMA, when no privs
} 

# Security / Auth
variable "rbac_enabled" { 
    type = bool    
    default = true 
}
variable "oidc_issuer_enabled" { 
    type = bool    
    default = true 
}

variable "aks_version" { 
    type = string  
    default = null # choose the latest one if null
}      

# Tagging
variable "tags" { 
    type = map(string) 
    default = {}
}
