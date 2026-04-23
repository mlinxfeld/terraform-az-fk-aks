module "aks" {
  source              = "../.."
  name                = "fk-aks-demo"
  create_rg           = true
  location            = var.location
  resource_group_name = var.resource_group_name

  create_networking = true
  network_plugin    = "kubenet"
}
