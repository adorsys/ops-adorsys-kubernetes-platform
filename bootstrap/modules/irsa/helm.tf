data "aws_region" "current" {}

resource "helm_release" "pod_identity_webhook" {
  chart      = "amazon-eks-pod-identity-webhook"
  name       = "amazon-eks-pod-identity-webhook"
  repository = "https://jkroepke.github.io/helm-charts/"
  version    = "1.0.3"
  namespace  = "ops-pod-identity-webhook"

  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 70

  values = [<<YAML
config:
  defaultAwsRegion: ${data.aws_region.current.name}
YAML
  ]
}
