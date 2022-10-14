provider "helm" {
  kubernetes {
    config_path = "../service.kubeconfig"
  }
}
