resource "kubectl_manifest" "app_project" {
  yaml_body  = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: app-of-apps
  namespace: ops-argocd
spec:
  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
  description: app-of-apps
  sourceRepos:
    - 'git@github.com:adorsys/ops-k8s-bootstrap.git'
  destinations:
    - namespace: 'ops-argocd'
      server: https://kubernetes.default.svc
YAML
  depends_on = [kubernetes_manifest.ns]
}

resource "kubectl_manifest" "app_of_apps" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-apps
  namespace: ops-argocd
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  project: app-of-apps
  source:
    kustomize: {}
    repoURL: git@github.com:adorsys/ops-k8s-bootstrap.git
    targetRevision: get_ready_for_workloads
    path: "${var.cluster_name}-cluster/applications"
  destination:
    server: https://kubernetes.default.svc
    namespace: ops-argocd
YAML

  depends_on = [
    helm_release.argocd
  ]
}

resource "kubectl_manifest" "ops_app_of_apps" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ops-app-of-apps
  namespace: ops-argocd
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  project: app-of-apps
  source:
    kustomize: {}
    repoURL: git@github.com:adorsys/ops-k8s-bootstrap.git
    targetRevision: get_ready_for_workloads
    path: "${var.cluster_name}-cluster/ops"
  destination:
    server: https://kubernetes.default.svc
    namespace: ops-argocd
YAML

  depends_on = [
    helm_release.argocd
  ]
}
