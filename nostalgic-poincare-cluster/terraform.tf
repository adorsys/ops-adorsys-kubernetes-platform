terraform {

  backend "s3" {
    bucket = "ops-k8s-bootstrap-tfstate"
    region = "eu-central-1"
    key    = "nostalgic-poincare-cluster.tfstate"

    encrypt = true
  }
}