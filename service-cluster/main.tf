module "gitops" {
  source = "../bootstrap/modules/argocd"

  cluster_name = var.cluster_name
}
