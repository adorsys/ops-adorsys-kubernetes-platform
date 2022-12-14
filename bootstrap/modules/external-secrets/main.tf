resource "helm_release" "external_secrets" {
  chart      = "external-secrets"
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  version    = "0.7.0"
  namespace  = "ops-external-secrets"

  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 200

  values = [
    <<YAML
installCRDs: true
YAML
  ]
  depends_on = [
    kubernetes_manifest.ns,
    aws_iam_role.assume_role
  ]
}
