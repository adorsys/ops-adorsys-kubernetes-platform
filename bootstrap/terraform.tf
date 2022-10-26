terraform {

  backend "s3" {
    bucket = "ops-k8s-bootstrap-tfstate"
    region = "eu-central-1"
    key    = "service-cluster.tfstate"

    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
  }
}
