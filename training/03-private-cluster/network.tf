module "vnet" {
  source = "github.com/mlinxfeld/terraform-az-fk-vnet"

  name                = "foggykitchen-vnet"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  address_space = ["10.0.0.0/16"]

  subnets = {
    foggykitchen-private-subnet = {
      address_prefixes = ["10.0.1.0/24"]
    }
    AzureBastionSubnet = {
      address_prefixes = ["10.0.2.0/26"]
    }
  }
}

module "routing" {
  source = "github.com/mlinxfeld/terraform-az-fk-routing"

  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  route_tables = {
    foggykitchen-aks-udr = {
      location = azurerm_resource_group.foggykitchen_rg.location
      subnet_ids = [
        module.vnet.subnet_ids["foggykitchen-private-subnet"]
      ]
    }
  }
}

module "natgw_public_ip" {
  source = "github.com/mlinxfeld/terraform-az-fk-public-ip"

  name                = "foggykitchen-natgw-ip"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
}

module "natgw" {
  source = "github.com/mlinxfeld/terraform-az-fk-natgw"

  name                = "foggykitchen-natgw"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  create_public_ip = false
  public_ip_id     = module.natgw_public_ip.id

  subnet_associations = {
    private_subnet = {
      subnet_id = module.vnet.subnet_ids["foggykitchen-private-subnet"]
    }
  }
}
