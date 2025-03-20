provider "helm" {
  kubernetes {
    config_path = ".kubeconfig"
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = ""

  default_tags {
    tags = {
      cluster = "showroom"
      service = "kaas"
      Owner   = "ops"
      Name    = "ops-k8s-bootstrap"
    }
  }
}

provider "kubectl" {
  load_config_file = true
  config_path      = ".kubeconfig"
}

provider "kubernetes" {
  config_path = ".kubeconfig"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
}
