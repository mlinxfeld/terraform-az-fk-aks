resource "local_file" "k8s-deploy" {
  content = templatefile("${path.module}/manifest/k8s-deploy.template.yaml", {
    acr_login_server = module.acr.acr_login_server
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
    image_url = "${module.acr.acr_login_server}/hello:1.0"
  })
  filename = "${path.module}/generated/index.html"
}

resource "null_resource" "acr_build" {
  depends_on = [
    module.acr,
    local_file.k8s-deploy,
    local_file.dockerfile_deployment,
    local_file.indexhtml_deployment
  ]

  provisioner "local-exec" {
    command = "az acr build -t ${module.acr.acr_login_server}/hello:1.0 -r ${module.acr.acr_name} ."
  }
}

resource "null_resource" "kubectl_apply" {
  depends_on = [
    module.acr_pull,
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
