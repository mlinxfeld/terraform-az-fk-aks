locals {
  tags = merge({ project = "foggykitchen-aks" }, var.tags)
}
