module "private_endpoint_acr" {
  source = "github.com/foggykitchen/terraform-az-fk-private-endpoint"
  count  = var.enable_acr_private_endpoint ? 1 : 0

  name                = "fk-acr-pe"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  subnet_id           = module.vnet.subnet_ids["fk-subnet-private-endpoints"]

  private_connection_resource_id = module.acr.acr_id
  subresource_names              = ["registry"]
  is_manual_connection           = false

  private_dns_zone_group_name = "acr-dns-zone-group"
  private_dns_zone_ids        = (var.enable_acr_private_endpoint && var.enable_private_dns) ? [module.private_dns[0].private_dns_zone_ids["privatelink.azurecr.io"]] : []

  tags = var.tags

  depends_on = [
    module.private_dns
  ]
}
