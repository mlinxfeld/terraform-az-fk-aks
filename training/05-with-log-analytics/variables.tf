variable "resource_group_name" {
  description = "The name of the Azure Resource Group where resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region (e.g., East US, West Europe)"
  type        = string
}

variable "acr_name" {
  description = "Globally unique Azure Container Registry name. Use only lowercase letters and numbers."
  type        = string
  default     = "fkacr1"
}
