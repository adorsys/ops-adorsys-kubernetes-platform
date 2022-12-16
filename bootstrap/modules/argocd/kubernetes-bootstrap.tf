data "aws_secretsmanager_secret" "github" {
  name = "kaas/github/argocd"
}

data "aws_secretsmanager_secret" "gitlab" {
  name = "kaas/gitlab/argocd"
}

data "aws_secretsmanager_secret_version" "github" {
  secret_id = data.aws_secretsmanager_secret.github.id
}

data "aws_secretsmanager_secret_version" "gitlab" {
  secret_id = data.aws_secretsmanager_secret.gitlab.id
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
    type          = "git"
    url           = "git@github.com:adorsys/ops-k8s-bootstrap.git"
    sshPrivateKey = data.aws_secretsmanager_secret_version.github.secret_string
  }
  depends_on = [kubernetes_manifest.ns]
}

resource "kubernetes_secret" "gitlab" {
  metadata {
    name      = "gitlab-secret"
    namespace = "ops-argocd"

    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  data = {
    username = jsondecode(data.aws_secretsmanager_secret_version.gitlab.secret_string)["GITLAB_KUBERMATIC_USERNAME"]
    password = jsondecode(data.aws_secretsmanager_secret_version.gitlab.secret_string)["GITLAB_KUBERMATIC_PASSWORD"]
    url      = "https://git.adorsys.de/"
    type     = "git"
  }
  depends_on = [kubernetes_manifest.ns]
}
