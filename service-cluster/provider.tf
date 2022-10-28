provider "helm" {
  kubernetes {
    config_path = "../.kubeconfig"
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = ""

  default_tags {
    tags = {
      project = "ops-k8s-bootstrap"
      Owner   = "ops"
      Name    = "ops-k8s-bootstrap"
    }
  }
}
