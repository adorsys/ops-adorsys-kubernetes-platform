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

provider "helm" {
  kubernetes {
    config_path = ".kubeconfig"
  }
}

provider "kubectl" {
  load_config_file = true
  config_path = ".kubeconfig"
}

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