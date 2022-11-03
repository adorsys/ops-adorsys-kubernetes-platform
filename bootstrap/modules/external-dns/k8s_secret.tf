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

resource "kubectl_manifest" "psp" {
  yaml_body = <<YAML
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: externaldns
spec:
  privileged: false
  allowPrivilegeEscalation: false
  volumes: []
  hostNetwork: false
  hostIPC: false
  hostPID: false
  runAsUser:
    rule: 'MustRunAsNonRoot'
  seLinux:
    rule: 'RunAsAny'
  supplementalGroups:
    rule: 'MustRunAs'
    ranges:
      - min: 65534
        max: 65534
  fsGroup:
    rule: 'MustRunAs'
    ranges:
      - min: 65534
        max: 65534
  readOnlyRootFilesystem: true
  requiredDropCapabilities:
    - ALL
YAML
}

resource "kubectl_manifest" "role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: externaldns
  namespace: ops-externaldns
rules:
  - apiGroups:
      - policy
    resources:
      - podsecuritypolicies
    verbs:
      - use
    resourceNames:
      - externaldns
YAML
}

resource "kubectl_manifest" "rb" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: externaldns
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: externaldns
subjects:
  - kind: ServiceAccount
    name: externaldns
    namespace: ops-externaldns
YAML
}