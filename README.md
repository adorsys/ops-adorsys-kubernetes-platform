# Kubernetes Bootstrapping

This repository bootstraps all k8s cluster provisioned by kubermatic.

The following tools are configured by **terraform**:
* argocd & github webhook
* dex
* external-dns/aws DNS configuration

The following tools are provided as ArgoCD `Applications`:
* stakater/reloader
* sealedsecrets
* kube-prometheus
* trivy

## Add new cluster
After the initial creation of the kubermatic cluster the following steps should
be necessary to bootstrap:

1. Create a ServiceAccount in Kubermatic and add the token as a secret in this
repo
2. Create a new branch
3. Create a new `*-cluster` folder and copy/adjust the `main.tf`
4. Review the PR and merge on `main`
