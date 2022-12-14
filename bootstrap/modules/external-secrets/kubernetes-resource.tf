resource "kubernetes_secret" "external_secrets" {
  metadata {
    name      = "external-secrets"
    namespace = "ops-external-secrets"
  }

  data = {
    access_key_id = aws_iam_access_key.externalsecrets.id
    secret_access_key = aws_iam_access_key.externalsecrets.secret
  }
  type = "Opaque"
  depends_on = [kubernetes_manifest.ns]
}