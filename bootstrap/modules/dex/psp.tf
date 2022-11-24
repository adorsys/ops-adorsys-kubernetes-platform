resource "kubectl_manifest" "psp" {
  yaml_body = <<YAML
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: default-dex
spec:
  allowedCapabilities:
    - NET_BIND_SERVICE
  privileged: false
  allowPrivilegeEscalation: false
  volumes:
    - configMap
    - secret
    - emptyDir
  hostNetwork: false
  hostIPC: false
  hostPID: false
  runAsUser:
    rule: RunAsAny #MustRunAsNonRoot
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    rule: MustRunAs
    ranges:
      - min: 1
        max: 65535
  fsGroup:
    rule: MustRunAs
    ranges:
      - min: 1
        max: 65535
  readOnlyRootFilesystem: false
  defaultAddCapabilities:
    - CHOWN
    - NET_BIND_SERVICE
    - SETGID
    - SETUID
  requiredDropCapabilities:
    - ALL
YAML
}

resource "kubectl_manifest" "role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: dex-psp
  namespace: ops-dex
rules:
  - apiGroups: [policy]
    resources: [podsecuritypolicies]
    verbs: [use]
    resourceNames: [default-dex]
YAML
  depends_on = [kubernetes_manifest.ns]
}

resource "kubectl_manifest" "rb" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dex-psp
  namespace: ops-dex
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: dex-psp
subjects:
  - kind: ServiceAccount
    name: dex
    namespace: ops-dex
YAML
  depends_on = [kubernetes_manifest.ns]
}

data "aws_secretsmanager_secret" "azure" {
  arn = "arn:aws:secretsmanager:eu-central-1:571075516563:secret:kaas/staging/dex/azure-adorsys-rAC4yf"
}

data "aws_secretsmanager_secret_version" "azure" {
  secret_id = data.aws_secretsmanager_secret.azure.id
}

resource "kubectl_manifest" "secret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: dex-azure-ad-connector
  namespace: ops-dex
type: Opaque
data:
  MICROSOFT_CLIENT_ID: ${base64encode(jsondecode(data.aws_secretsmanager_secret_version.azure.secret_string)["DEX_MICROSOFT_CLIENT_ID"])}
  MICROSOFT_CLIENT_SECRET: ${base64encode(jsondecode(data.aws_secretsmanager_secret_version.azure.secret_string)["DEX_MICROSOFT_CLIENT_SECRET"])}
YAML
  depends_on = [kubernetes_manifest.ns]
}

resource "random_password" "dex_argocd_client" {
  length  = 16
  special = false
}

resource "kubectl_manifest" "dex_argocd_client" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: dex-argocd-client
  namespace: ops-argocd
  labels:
    app.kubernetes.io/part-of: argocd
type: Opaque
data:
  client-id: ${base64encode("argo")}
  client-secret: ${base64encode(random_password.dex_argocd_client.result)}
YAML
  depends_on = [kubernetes_manifest.ns]
}

resource "kubectl_manifest" "dex_argocd_dex_client" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: dex-argocd
  namespace: ops-dex
type: Opaque
data:
  client-id: ${base64encode("argo")}
  client-secret: ${base64encode(random_password.dex_argocd_client.result)}
YAML
  depends_on = [kubernetes_manifest.ns]
}