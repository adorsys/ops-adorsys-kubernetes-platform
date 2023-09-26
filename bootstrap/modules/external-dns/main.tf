resource "helm_release" "external_dns" {
  chart      = "external-dns"
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  version    = "1.13.1"
  namespace  = "ops-externaldns"

  atomic          = true
  cleanup_on_fail = true
  lint            = true
  timeout         = 200

  values = [
    <<YAML
domainFilters:
  ${indent(2, yamlencode(var.dns_managed_zones))}
env:
  - name: AWS_DEFAULT_REGION
    value: eu-central-1
  - name: AWS_SHARED_CREDENTIALS_FILE
    value: /.aws/credentials
extraVolumeMounts:
  - name: aws-credentials
    mountPath: /.aws
    readOnly: true
extraVolumes:
  - name: aws-credentials
    secret:
      secretName: external-dns

YAML
  ]
  depends_on = [kubernetes_manifest.ns]
}
