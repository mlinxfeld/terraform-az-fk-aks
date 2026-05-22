module "vnet" {
  source = "github.com/foggykitchen/terraform-az-fk-vnet"

  name                = var.vnet_name
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  address_space = ["10.30.0.0/16"]

  subnets = {
    fk-subnet-aks = {
      address_prefixes = ["10.30.8.0/22"]
    }

    fk-subnet-private-endpoints = {
      address_prefixes                  = ["10.30.20.0/24"]
      private_endpoint_network_policies = "Disabled"
    }
  }

  tags = var.tags
}
