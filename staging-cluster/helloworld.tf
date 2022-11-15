resource "kubectl_manifest" "test_application" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: helloworld
  namespace: ops-argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  labels:
    name: helloworld
spec:
  project: default
  source:
    repoURL: https://github.com/adorsys/ops-k8s-helloworld.git
    targetRevision: main
    path: kubernetes
    kustomize: {}
  destination:
    server: https://kubernetes.default.svc
    namespace: helloworld
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    syncOptions:
    - Validate=true
    - CreateNamespace=true
    - PrunePropagationPolicy=foreground
    - PruneLast=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
  revisionHistoryLimit: 3
YAML
}
