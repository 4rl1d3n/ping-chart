# Data source to get resource group and name of the registry
data "azurerm_container_registry" "destination_acr" {
  name                = var.acr_server
  resource_group_name = var.acr_resource_group
}

# Import chart to registry
resource "azurerm_container_registry_import" "copy_helm_chart" {
  count = length(var.charts) # Instance a resource for each chart in the list

  name                = "${var.charts[count.index].chart_repository}:${var.charts[count.index].chart_version}"
  resource_group_name = data.azurerm_container_registry.destination_acr.resource_group_name
  registry_name       = data.azurerm_container_registry.destination_acr.name

  source {
    registry_uri = "${var.source_acr_server}/${var.charts[count.index].chart_repository}:${var.charts[count.index].chart_version}"
    credentials {
      username = var.source_acr_client_id
      password = var.source_acr_client_secret
    }
  }
}

# Deploy in AKS
resource "helm_release" "charts" {
  count = length(var.charts)

  name       = var.charts[count.index].chart_name
  repository = "${data.azurerm_container_registry.destination_acr.login_server}/${var.charts[count.index].chart_repository}"
  version    = var.charts[count.index].chart_version
  namespace  = var.charts[count.index].chart_namespace

  values = var.charts[count.index].values

  dynamic "set_sensitive" {
    for_each = var.charts[count.index].sensitive_values
    content {
      name  = set_sensitive.key
      value = set_sensitive.value
    }
  }

  depends_on = [
    azurerm_container_registry_import.copy_helm_chart,
  ]
}