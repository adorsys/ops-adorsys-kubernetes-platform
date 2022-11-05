module "dns" {
  source = "../bootstrap/modules/external-dns"

  cluster_name = var.cluster_name
}

module "ingress" {
  source = "../bootstrap/modules/ingress-nginx"
}

module "cert-manager" {
  source = "../bootstrap/modules/cert-manager"
}

module "irsa" {
  source = "../bootstrap/modules/irsa"

  cluster_api = "https://${var.cluster_id}.adorsys.kaas.cloudpunks.io:${var.cluster_port}"
}



resource "aws_iam_role" "s3" {
  name               = "s3_echoer"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "this" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.s3.name
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["arn:aws:iam::571075516563:oidc-provider/kubermatic-staging-irsa.s3.eu-central-1.amazonaws.com"]
      type        = "Federated"
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "kubermatic-staging-irsa.s3.eu-central-1.amazonaws.com:aud"
    }

    condition {
      test     = "StringEquals"
      values   = "system:serviceaccount:default:s3_echoer"
      variable = "kubermatic-staging-irsa.s3.eu-central-1.amazonaws.com:sub"
    }
  }
}

resource "kubectl_manifest" "echoer" {
  yaml_body = <<YAML
apiVersion: batch/v1
kind: Job
metadata:
  name: s3-echoer
spec:
  template:
    spec:
      serviceAccountName: s3_echoer
      containers:
      - name: main
        image: amazonlinux
        command:
        - "sh"
        - "-c"
        - "aws sts get-caller-identity"
YAML
}

resource "kubectl_manifest" "psp" {
  yaml_body = <<YAML
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: s3echoer
spec:
  privileged: false
  allowPrivilegeEscalation: false
  volumes:
    - projected
    - secret
  hostNetwork: false
  hostIPC: false
  hostPID: false
  runAsUser:
    rule: 'MustRunAsNonRoot'
  seLinux:
    rule: 'RunAsAny'
  supplementalGroups:
    rule: 'MustRunAs'
    ranges:
      - min: 65534
        max: 65534
  fsGroup:
    rule: 'MustRunAs'
    ranges:
      - min: 65534
        max: 65534
  readOnlyRootFilesystem: true
  requiredDropCapabilities:
    - ALL
YAML
}

resource "kubectl_manifest" "role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: s3echoer
  namespace: default
rules:
  - apiGroups:
      - policy
    resources:
      - podsecuritypolicies
    verbs:
      - use
    resourceNames:
      - s3echoer
YAML
}

resource "kubectl_manifest" "rb" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: s3echoer
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: s3echoer
subjects:
  - kind: ServiceAccount
    name: s3_echoer
    namespace: default
YAML
}
