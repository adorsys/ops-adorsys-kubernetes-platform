resource "kubectl_manifest" "app_project" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: app-of-apps
  namespace: ops-argocd
spec:
  description: app-of-apps
  sourceRepos:
    - 'git@github.com:adorsys/ops-k8s-bootstrap.git'
  destinations:
    - namespace: 'ops-app-of-*'
      server: https://kubernetes.default.svc
      clusterResourceWhitelist:
        - group: '*'
          kind: '*'
YAML
  depends_on = [kubernetes_manifest.ns]
}
