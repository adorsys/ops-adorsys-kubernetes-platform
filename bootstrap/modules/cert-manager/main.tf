resource "helm_release" "cert_manager" {
  chart      = "cert-manager"
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = "v1.10.0"
  namespace  = "ops-cert-manager"

  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 70

  values = [
    <<YAML
installCRDs: true
global:
  podSecurityPolicy:
    enabled: true
extraArgs:
  - --default-issuer-name=letsencrypt
  - --default-issuer-kind=ClusterIssuer
YAML
  ]
}