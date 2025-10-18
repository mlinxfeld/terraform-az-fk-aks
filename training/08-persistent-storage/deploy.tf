resource "local_file" "disk-demo" {
  content = templatefile("${path.module}/manifest/disk-demo.template.yaml", {
  })
  filename = "${path.module}/generated/disk-demo.yaml"
}

resource "local_file" "file-demo" {
  content = templatefile("${path.module}/manifest/file-demo.template.yaml", {
  })
  filename = "${path.module}/generated/file-demo.yaml"
}


resource "null_resource" "kubectl_apply" {
  depends_on = [
    module.aks,
    local_file.disk-demo,
    local_file.file-demo
  ]

  provisioner "local-exec" {
    command = join(" && ", [
      "az aks get-credentials -g ${azurerm_resource_group.foggykitchen_rg.name} -n ${module.aks.cluster_name} --overwrite-existing",
      "kubectl apply -f ${path.module}/generated/disk-demo.yaml",
      "kubectl apply -f ${path.module}/generated/file-demo.yaml",
      "kubectl get pvc",
      "kubectl get pv",
      "kubectl get pods -o wide"
    ])
  }
}