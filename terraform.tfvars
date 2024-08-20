acr_server               = "instance.azurecr.io"
acr_server_subscription  = "c9e7611c-d508-4fbf-aede-0bedfabc1560"
source_acr_client_id     = "1b2f651e-b99c-4720-9ff1-ede324b8ae30"
source_acr_client_secret = "Zrrr8~5~F2Xiaaaa7eS.S85SXXAAfTYizZEF1cRp"
source_acr_server        = "reference.azurecr.io"

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
