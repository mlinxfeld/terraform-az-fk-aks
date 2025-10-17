resource "local_file" "k8s-deploy" {
  content = templatefile("${path.module}/manifest/k8s-deploy.template.yaml", {
    acr_login_server = azurerm_container_registry.fk-acr1.login_server
  })
  filename = "${path.module}/generated/k8s-deploy.yaml"
}

resource "local_file" "dockerfile_deployment" {
  content = templatefile("${path.module}/manifest/dockerfile.template", {
  })
  filename = "${path.module}/Dockerfile"
}

resource "local_file" "indexhtml_deployment" {
  content = templatefile("${path.module}/manifest/index.template.html", {
    image_url = "${azurerm_container_registry.fk-acr1.login_server}/hello:1.0" 
  })
  filename = "${path.module}/generated/index.html"
}

resource "null_resource" "acr_build" {
  depends_on = [
  module.aks,
  azurerm_container_registry.fk-acr1,
  azurerm_role_assignment.fk-acr1_pull,
  local_file.k8s-deploy,
  local_file.dockerfile_deployment,
  local_file.indexhtml_deployment
  ]

  provisioner "local-exec" {
    command = "az acr build -t ${azurerm_container_registry.fk-acr1.login_server}/hello:1.0 -r ${azurerm_container_registry.fk-acr1.name} ."
  }
}  

resource "null_resource" "kubectl_apply" {
  depends_on = [
    null_resource.acr_build
  ]

  provisioner "local-exec" {
    command = join(" && ", [
      "az aks get-credentials -g ${azurerm_resource_group.foggykitchen_rg.name} -n ${module.aks.cluster_name} --overwrite-existing",
      "kubectl apply -f ${path.module}/generated/k8s-deploy.yaml",
      "kubectl rollout status deploy/fk-acr-demo --timeout=120s"
    ])
  }
}