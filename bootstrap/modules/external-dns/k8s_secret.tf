resource "kubectl_manifest" "secret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: external-dns
  namespace: ops-externaldns

type: Opaque
stringData:
  credentials: |
    [default]
    aws_access_key_id = ${aws_iam_access_key.externaldns.id}
    aws_secret_access_key = ${aws_iam_access_key.externaldns.secret}
YAML
}