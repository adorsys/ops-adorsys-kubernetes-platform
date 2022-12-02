data "aws_secretsmanager_secret" "azure" {
  arn = "arn:aws:secretsmanager:eu-central-1:571075516563:secret:kaas/staging/dex/azure-adorsys-rAC4yf"
}

data "aws_secretsmanager_secret_version" "azure" {
  secret_id = data.aws_secretsmanager_secret.azure.id
}

resource "kubernetes_pod_security_policy" "default-dex" {
  metadata {
    name = "default-dex"
  }
  spec {
    privileged                 = false
    allow_privilege_escalation = false
    default_add_capabilities   = ["CHOWN", "NET_BIND_SERVICE", "SETGID", "SETUID"]
    required_drop_capabilities = ["ALL"]
    allowed_capabilities       = ["NET_BIND_SERVICE"]


    volumes = [
      "configMap",
      "emptyDir",
      "secret"
    ]

    run_as_user {
      rule = "RunAsAny"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }
  }
}

resource "kubernetes_role" "dex_role" {
  metadata {
    name      = "dex-role"
    namespace = "ops-dex"
  }

  rule {
    verbs          = ["use"]
    api_groups     = ["policy"]
    resources      = ["podsecuritypolicies"]
    resource_names = ["default-dex"]
  }
  depends_on = [kubernetes_manifest.ns]
}

resource "kubernetes_role_binding" "dex_psp" {
  metadata {
    name      = "dex-psp"
    namespace = "ops-dex"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "dex"
    namespace = "ops-dex"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "dex-role"
  }
  depends_on = [kubernetes_manifest.ns]
}

resource "kubernetes_secret" "dex_azure_ad_connector" {
  metadata {
    name      = "dex-azure-ad-connector"
    namespace = "ops-dex"
  }

  data = {
    MICROSOFT_CLIENT_ID = jsondecode(data.aws_secretsmanager_secret_version.azure.secret_string)["DEX_MICROSOFT_CLIENT_ID"]
    MICROSOFT_CLIENT_SECRET = jsondecode(data.aws_secretsmanager_secret_version.azure.secret_string)["DEX_MICROSOFT_CLIENT_SECRET"]
  }

  type = "Opaque"
  depends_on = [kubernetes_manifest.ns]
}

resource "random_password" "dex_argocd_client" {
  length  = 16
  special = false
}

resource "kubernetes_secret" "dex_argocd_client" {
  metadata {
    name      = "dex-argocd-client"
    namespace = "ops-argocd"

    labels = {
      "app.kubernetes.io/part-of" = "argocd"
    }
  }

  data = {
    client-id = "argo"
    client-secret = random_password.dex_argocd_client.result
  }

  type = "Opaque"
  depends_on = [kubernetes_manifest.ns]
}

resource "kubernetes_secret" "dex_argocd" {
  metadata {
    name      = "dex-argocd"
    namespace = "ops-dex"
  }

  data = {
    client-id = "argo"
    client-secret = random_password.dex_argocd_client.result
  }

  type = "Opaque"
  depends_on = [kubernetes_manifest.ns]
}





