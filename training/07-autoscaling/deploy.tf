resource "local_file" "heavy-deploy" {
  content = templatefile("${path.module}/manifest/heavy-deploy.template.yaml", {
  })
  filename = "${path.module}/generated/heavy-deploy.yaml"
}

resource "null_resource" "kubectl_apply" {
  depends_on = [
    module.aks,
    local_file.heavy-deploy
  ]

  provisioner "local-exec" {
    command = join(" && ", [
      "az aks get-credentials -g ${azurerm_resource_group.foggykitchen_rg.name} -n ${module.aks.cluster_name} --overwrite-existing",
      "kubectl get nodes -L agentpool,workload,sku",
      "kubectl apply -f ${path.module}/generated/heavy-deploy.yaml",
      "kubectl get pods -l app=heavy -o wide"
    ])
  }
}