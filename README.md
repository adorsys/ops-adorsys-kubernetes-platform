# :cloud: Kubernetes Bootstrapping

This repository bootstraps all k8s cluster provisioned by kubermatic.

The following tools are configured by **terraform**:
* external-dns
* nginx ingress
* certmanager with letsencrypt
* argocd & github webhook
* dex

The following tools are provided as ArgoCD `Applications`:
* stakater/reloader
* sealedsecrets
* kube-prometheus
* trivy

## :grey_question: Add new cluster
After the initial creation of the kubermatic cluster the following steps should
be necessary to bootstrap:

1. Create a ServiceAccount in Kubermatic and add the token as a secret in this
repo
2. Create a new branch
3. Create a new `*-cluster` folder and copy/adjust the `main.tf`
4. Review the PR and merge on `main`

## Initial Setup
> **Note**
>
> This is done once(!) and here for documentation purpose only. If we switch
> aws accounts or basic infrastructure, some tasks might be neccessary again.

### User Setup in AWS for terraform-github action
* Create an IAM User in the aws account [#3](https://github.com/adorsys/ops-k8s-bootstrap/issues/3)
* Create a tfstate Bucket and allow that user to configure it [#2](https://github.com/adorsys/ops-k8s-bootstrap/issues/2)
* Update the TF IAM User to allow IAM User creation for DNS Management [#5](https://github.com/adorsys/ops-k8s-bootstrap/issues/5)
