resource "helm_release" "argocd" {
  chart      = "argo-cd"
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.42.2"
  namespace  = "ops-argocd"

  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 70

  values = [
    <<YAML
dex:
  enabled: false
configs:
  rbac:
    policy.default: "role:readonly"
    policy.csv: |
      p, role:readonly, applications, sync, */*, allow
      p, role:readonly, applications, action/*, */*, allow
server:
  extraArgs:
    - --insecure
  config:
    oidc.config: |
      name: Microsoft
      issuer: https://login.${var.cluster_name}.adorsys.io/dex/
      clientID: $dex-argocd-client:client-id
      clientSecret: $dex-argocd-client:client-secret
      requestedIDTokenClaims:
        groups:
          essential: false
      requestedScopes:
        - openid
        - email
        - profile
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
  depends_on = [kubernetes_manifest.ns]
}

