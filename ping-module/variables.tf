variable "acr_server" {
  description = "Servidor ACR de destino "
  type        = string
}

variable "acr_server_subscription" {
  description = "Id ACR de destino."
  type        = string
}

variable "source_acr_client_id" {
  description = "Id ACR de origen."
  type        = string
}

variable "source_acr_client_secret" {
  description = "source acr client secret"
  type        = string
  sensitive   = true
}

variable "source_acr_server" {
  description = "Servidor ACR origen"
  type        = string
}

variable "charts" {
  description = "Chart list"
  type = list(object({
    chart_name       = string
    chart_namespace  = string
    chart_repository = string
    chart_version    = string
    values           = map(string)
    sensitive_values = map(string)
  }))
}
