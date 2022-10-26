module "gitops" {
  source = "../bootstrap/modules/argocd"

  cluster_name = var.cluster_name
}

data "aws_caller_identity" "current" {}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}
