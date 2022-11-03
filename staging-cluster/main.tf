module "dns" {
  source = "../bootstrap/modules/external-dns"

  cluster_name = var.cluster_name
}

module "ingress_controller" {
  source = "../bootstrap/modules/ingress-controller"

  cluster_name = var.cluster_name
}

module "cert-manager" {
  source = "../bootstrap/modules/cert-manager"

  cluster_name = var.cluster_name
}

