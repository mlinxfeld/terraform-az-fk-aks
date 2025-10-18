resource "local_file" "app-on-userpool" {
  content = templatefile("${path.module}/manifest/app-on-userpool.template.yaml", {
  })
  filename = "${path.module}/generated/app-on-userpool.yaml"
}

resource "null_resource" "kubectl_apply" {
  depends_on = [
    module.aks,
    local_file.app-on-userpool
  ]

  provisioner "local-exec" {
    command = join(" && ", [
      "az aks get-credentials -g ${azurerm_resource_group.foggykitchen_rg.name} -n ${module.aks.cluster_name} --overwrite-existing",
      "kubectl get nodes -L agentpool,workload,sku",
      "kubectl apply -f ${path.module}/generated/app-on-userpool.yaml",
      "kubectl get pods -o wide"
    ])
  }
}