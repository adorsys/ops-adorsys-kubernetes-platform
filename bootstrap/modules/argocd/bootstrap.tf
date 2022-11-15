data "aws_secretsmanager_secret" "argocd" {
  arn = "arn:aws:secretsmanager:eu-central-1:571075516563:secret:kaas/staging/argocd/githubssh-AtK3C8"
}

data "aws_secretsmanager_secret_version" "argocd" {
  secret_id = data.aws_secretsmanager_secret.argocd.id
}

resource "kubectl_manifest" "secret" {
  sensitive_fields = ["stringData"]
  yaml_body        = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: ops-k8s-bootstrap
  namespace: ops-argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: git@github.com:adorsys/ops-k8s-bootstrap.git
  sshPrivateKey: ${jsondecode(data.aws_secretsmanager_secret_version.argocd.secret_string)["GITHUB_PRIVATEKEY_SSH"]}
YAML
}

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
}
