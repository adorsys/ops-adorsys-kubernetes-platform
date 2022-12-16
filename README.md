# :cloud: Kubernetes as an adorsys Service

This repository bootstraps all adorsys-k8s cluster provisioned by kubermatic.

If you, as an adorsys developer need help, [consult our wiki](https://github.com/adorsys/ops-k8s-bootstrap/wiki).

## Available Tools
The following tools are available for the clusters

* external-dns
* nginx ingress
* certmanager with letsencrypt
* argocd with gitlab & github access
* dex with azure as idp
* external-secrets for accessing the aws-secretstore

## OPS Docu
This section is only relevant for the ops ppl.

### Initial Setup
> **Note**
>
> This is done once(!) and here for documentation purpose only. If we switch
> aws accounts or basic infrastructure, some tasks might be neccessary again.

Terraform should run with YOUR IAM profile configured:
```bash
# in the root folder of this repo
export AWS_PROFILE=new-profile
terraform init
terraform apply
```
Further information is available in #56.

### :grey_question: Add new cluster
After the initial creation of the kubermatic cluster the following steps should
be necessary to bootstrap:

1. Create a new branch
2. Create a new `*-cluster` folder and copy/adjust most of the  `*.tf` from
an existing cluster
3. Review the PR and merge on `main`

