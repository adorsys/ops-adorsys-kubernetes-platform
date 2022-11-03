terraform {

  backend "s3" {
    bucket = "ops-k8s-bootstrap-tfstate"
    region = "eu-central-1"
    key    = "staging-cluster.tfstate"

    encrypt = true
  }

  kubectl = {
    source  = "gavinbunney/kubectl"
    version = "~> 1.13"
  }
}