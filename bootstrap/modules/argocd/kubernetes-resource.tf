resource "kubernetes_pod_security_policy" "default_argocd" {
  metadata {
    name = "default-argocd"

    annotations = {
      "seccomp.security.alpha.kubernetes.io/allowedProfileNames" = "runtime/default"
      "seccomp.security.alpha.kubernetes.io/defaultProfileName" = "runtime/default"
    }
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

resource "kubernetes_role" "argocd_psp" {
  metadata {
    name      = "argocd-psp"
    namespace = "ops-argocd"
  }

  rule {
    verbs          = ["use"]
    api_groups     = ["policy"]
    resources      = ["podsecuritypolicies"]
    resource_names = ["default-argocd"]
  }
  depends_on = [kubernetes_manifest.ns]
}

resource "kubernetes_role_binding" "argocd_psp" {
  metadata {
    name      = "argocd-psp"
    namespace = "ops-argocd"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "ops-argocd"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "argocd-notifications-controller"
    namespace = "ops-argocd"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "argocd-applicationset-controller"
    namespace = "ops-argocd"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "argocd-server"
    namespace = "ops-argocd"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "argocd-repo-server"
    namespace = "ops-argocd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "argocd-psp"
  }
  depends_on = [kubernetes_manifest.ns]
}
