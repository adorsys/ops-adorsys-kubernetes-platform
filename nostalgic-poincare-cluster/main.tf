#modules
module "argocd" {
  source = "../bootstrap/modules/argocd"

  cluster_name = var.cluster_name
}

module "cert-manager" {
  source = "../bootstrap/modules/cert-manager"
}

module "dex" {
  source = "../bootstrap/modules/dex"

  cluster_name = var.cluster_name
}

module "dns" {
  source = "../bootstrap/modules/external-dns"

  cluster_name = var.cluster_name
}

module "ingress" {
  source = "../bootstrap/modules/ingress-nginx"
}

# irsa is POCed with #16
#module "irsa" {
#  source = "../bootstrap/modules/irsa"
#
#}
