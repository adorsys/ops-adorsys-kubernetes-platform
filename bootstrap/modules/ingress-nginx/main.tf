resource "helm_release" "ingress_nginx" {
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx/"
  version    = "1.4.0"
  namespace  = "ops-ingress-nginx"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 70

  values = [
    <<YAML
  controller:
    service:
      annotations:
        external-dns.alpha.kubernetes.io/hostname: adorsys.io
YAML
]
}