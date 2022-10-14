resource "helm_release" "argocd" {
  chart      = "argo-cd"
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.5.16"
  namespace  = "ops-argocd"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 70

  values = [
    <<YAML
dex:
  enabled: false
server:
  extraArgs:
    - --insecure
  config:
    url: https://argocd-${var.cluster_name}.adorsys.kaas.cloudpunks.dev
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - argocd-${var.cluster_name}.adorsys.kaas.cloudpunks.dev
    tls:
      - hosts:
        - argocd-${var.cluster_name}.adorsys.kaas.cloudpunks.dev
        secretName: adorsys-wildcard
YAML
    , var.argocd_values
  ]
}

