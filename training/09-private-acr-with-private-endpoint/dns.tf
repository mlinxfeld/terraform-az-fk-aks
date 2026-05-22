module "private_dns" {
  source = "github.com/foggykitchen/terraform-az-fk-private-dns"
  count  = var.enable_acr_private_endpoint && var.enable_private_dns ? 1 : 0

  resource_group_name    = azurerm_resource_group.foggykitchen_rg.name
  private_dns_zone_names = ["privatelink.azurecr.io"]
  tags                   = var.tags

  vnet_links = {
    "acr-dns-link" = {
      vnet_id              = module.vnet.vnet_id
      registration_enabled = false
    }
  }
}
