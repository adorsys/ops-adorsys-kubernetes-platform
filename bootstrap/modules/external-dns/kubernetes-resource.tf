resource "kubernetes_secret" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "ops-externaldns"
  }

  data = {
    credentials =  <<EOF
      [default]
      aws_access_key_id     = ${aws_iam_access_key.externaldns.id}
      aws_secret_access_key = ${aws_iam_access_key.externaldns.secret}
EOF
  }
  type = "Opaque"
  depends_on = [kubernetes_manifest.ns]
}

resource "kubernetes_pod_security_policy" "external-dns" {
  metadata {
    name = "external-dns"
  }
  spec {
    privileged                 = false
    allow_privilege_escalation = false
    required_drop_capabilities = ["ALL"]
    allowed_capabilities       = ["NET_BIND_SERVICE"]

    volumes = [
      "projected",
      "secret"
    ]

    run_as_user {
      rule = "MustRunAsNonRoot"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 65534
        max = 65534
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 65534
        max = 65534
      }
    }
  }
}

resource "kubernetes_role" "externaldns" {
  metadata {
    name      = "externaldns"
    namespace = "ops-externaldns"
  }

  rule {
    verbs          = ["use"]
    api_groups     = ["policy"]
    resources      = ["podsecuritypolicies"]
    resource_names = ["external-dns"]
  }
  depends_on = [kubernetes_manifest.ns]
}

resource "kubernetes_role_binding" "externaldns" {
  metadata {
    name      = "externaldns"
    namespace = "ops-externaldns"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "external-dns"
    namespace = "ops-externaldns"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "externaldns"
  }
  depends_on = [kubernetes_manifest.ns]
}