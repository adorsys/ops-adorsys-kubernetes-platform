data "aws_secretsmanager_secret" "argocd" {
  arn = "arn:aws:secretsmanager:eu-central-1:571075516563:secret:kaas/staging/argocd/githubssh-AtK3C8"
}

data "aws_secretsmanager_secret_version" "argocd" {
  secret_id = data.aws_secretsmanager_secret.argocd.id
}

resource "kubernetes_secret" "ops_k8s_bootstrap" {
  metadata {
    name      = "ops-k8s-bootstrap"
    namespace = "ops-argocd"

    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type = "git"
    url =  "git@github.com:adorsys/ops-k8s-bootstrap.git"
    sshPrivateKey = jsondecode(data.aws_secretsmanager_secret_version.argocd.secret_string)["GITHUB_PRIVATEKEY_SSH"]
  }
  depends_on = [kubernetes_manifest.ns]
}
