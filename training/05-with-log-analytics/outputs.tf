output "acr_login_server" {
  value = module.acr.acr_login_server
}

output "acr_name" {
  value = module.acr.acr_name
}

output "acr_id" {
  value = module.acr.acr_id
}

output "cluster_name" {
  value = module.aks.cluster_name
}

output "acr_pull_role_assignment_id" {
  value = module.acr_pull.role_assignment_id
}

output "log_analytics_workspace_id" {
  value = module.aks.log_analytics_workspace_id
}
