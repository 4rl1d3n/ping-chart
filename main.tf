provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

module "ping_chart" {
  source = "./ping-module"  # 
  acr_server              = var.acr_server
  acr_resource_group      = azurerm_resource_group.rg.name
  acr_server_subscription = var.acr_server_subscription
  source_acr_client_id    = var.source_acr_client_id
  source_acr_client_secret = var.source_acr_client_secret
  source_acr_server       = var.source_acr_server
  charts = [
  {
    chart_name       = "ping"
    chart_namespace  = "default"
    chart_repository = "ping-repo"
    chart_version    = "0.1.0"
    values = {
      replicaCount = "3"
    }
    sensitive_values = {
      apiKey = "super-secret-api-key"
    }
  }
]

}
