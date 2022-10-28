module "dns" {
  source = "../bootstrap/modules/external-dns"

  cluster_name = var.cluster_name
}


