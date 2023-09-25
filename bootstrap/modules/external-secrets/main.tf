# we don't deploy any PSP which we currently need
# but the setup is working with our default PSP provisioned by argocd
resource "helm_release" "external_secrets" {
  chart      = "external-secrets"
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  version    = "0.9.5"
  namespace  = "ops-external-secrets"

  atomic          = true
  cleanup_on_fail = true
  lint            = true
  timeout         = 200

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
