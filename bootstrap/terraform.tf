terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

