module "vnet" {
  source = "github.com/mlinxfeld/terraform-az-fk-vnet"

  name                = "foggykitchen-vnet"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  address_space = ["10.10.0.0/16"]

  subnets = {
    foggykitchen-subnet = {
      address_prefixes = ["10.10.1.0/24"]
    }
  }
}
