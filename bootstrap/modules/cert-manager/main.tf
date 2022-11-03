resource "helm_release" "crt_manager" {
  chart      = "crt-manager"
  name       = "crtmanager"
  repository = "https://github.com/cert-manager/cert-manager"
  version    = ""
  namespace  = "ops-crt-manager"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 70

  values = [
    <<YAML
https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/templates/deployment.yaml
YAML
  ]
}
