module "dns" {
  source = "../bootstrap/modules/external-dns"

  cluster_name = var.cluster_name
}

module "ingress" {
  source = "../bootstrap/modules/ingress-nginx"

}

