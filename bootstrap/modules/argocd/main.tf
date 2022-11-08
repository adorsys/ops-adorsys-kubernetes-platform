resource "helm_release" "argocd" {
  chart      = "argo-cd"
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.13.6"
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
    url: https://argocd.${var.cluster_name}.adorsys.io
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      kubernetes.io/tls-acme: "true"
    hosts:
      - argocd.${var.cluster_name}.adorsys.io
    tls:
      - hosts:
        - argocd.${var.cluster_name}.adorsys.io
        secretName: argocd-ingress
YAML
    , var.argocd_values
  ]
}

