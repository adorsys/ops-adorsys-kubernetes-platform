resource "kubernetes_manifest" "ns" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name"      = "ops-external-secrets"
    }
  }
}