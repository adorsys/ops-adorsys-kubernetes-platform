data "aws_region" "current" {}

resource "helm_release" "pod_identity_webhook" {
  chart      = "amazon-eks-pod-identity-webhook"
  name       = "amazon-eks-pod-identity-webhook"
  repository = "https://jkroepke.github.io/helm-charts/"
  version    = "1.0.3"
  namespace  = "ops-pod-identity-webhook"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 70

  values = [<<YAML
config:
  defaultAwsRegion: ${data.aws_region.current.name}
YAML
  ]
}

resource "kubectl_manifest" "psp" {
  yaml_body = <<YAML
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: pod-identity-webhook
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
  name: pod-identity-webhook
  namespace: ops-pod-identity-webhook
rules:
  - apiGroups:
      - policy
    resources:
      - podsecuritypolicies
    verbs:
      - use
    resourceNames:
      - pod-identity-webhook
YAML
}

resource "kubectl_manifest" "rb" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-identity-webhook
  namespace: ops-pod-identity-webhook
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-identity-webhook
subjects:
  - kind: ServiceAccount
    name: default
    namespace: ops-pod-identity-webhook
YAML
}
