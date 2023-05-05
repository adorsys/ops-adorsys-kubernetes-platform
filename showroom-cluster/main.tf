module "argocd" {
  source = "../bootstrap/modules/argocd"

  cluster_name = var.cluster_name

  depends_on = [
    module.ingress
  ]

}

module "cert-manager" {
  source = "../bootstrap/modules/cert-manager"
}

module "dex" {
  source = "../bootstrap/modules/dex"

  cluster_name = var.cluster_name

  depends_on = [
    module.argocd
  ]
}

module "dns" {
  source = "../bootstrap/modules/external-dns"

  cluster_name = var.cluster_name

  dns_managed_zones = [
    "adorsys.io"
  ]
}

module "external-secrets" {
  source = "../bootstrap/modules/external-secrets"

  cluster_name = var.cluster_name

  # we need the default psp deployed
  depends_on = [
    module.argocd
  ]
}

module "ingress" {
  source = "../bootstrap/modules/ingress-nginx"
}