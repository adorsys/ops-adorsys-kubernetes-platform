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
