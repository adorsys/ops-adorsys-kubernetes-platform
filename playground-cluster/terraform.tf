terraform {

  backend "s3" {
    bucket = "ops-kaas-tfstate"
    region = "eu-central-1"
    key    = "playground-cluster.tfstate"

    encrypt = true
  }
}
