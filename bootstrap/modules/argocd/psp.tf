resource "kubectl_manifest" "psp" {
  yaml_body = <<YAML
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: default-argocd
  annotations:
    seccomp.security.alpha.kubernetes.io/allowedProfileNames: 'runtime/default'
    seccomp.security.alpha.kubernetes.io/defaultProfileName:  'runtime/default'
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
  name: argocd-psp
  namespace: ops-argocd
rules:
  - apiGroups: [policy]
    resources: [podsecuritypolicies]
    verbs: [use]
    resourceNames: [default-argocd]
YAML
  depends_on = [kubernetes_manifest.ns]
}

resource "kubectl_manifest" "rb" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: argocd-psp
  namespace: ops-argocd
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: argocd-psp
subjects:
  - kind: ServiceAccount
    name: default
    namespace: ops-argocd
  - kind: ServiceAccount
    name: argocd-notifications-controller
    namespace: ops-argocd
  - kind: ServiceAccount
    name: argocd-applicationset-controller
    namespace: ops-argocd
  - kind: ServiceAccount
    name: argocd-server
    namespace: ops-argocd
  - kind: ServiceAccount
    name: argocd-repo-server
    namespace: ops-argocd
YAML
  depends_on = [kubernetes_manifest.ns]
}
