<div align="center">
<img src="docs/imgs/logo.png" width="200">

[![adorsys][page-img]][page]
[![apply][apply-badge]][apply-url]
[![License: Apache-2.0][license-img]][license]

[📖 Documentation][docs]
</div>

# :cloud: akp - adorsys kubernetes platform

This repository bootstraps all adorsys-k8s cluster, provisioned by kubermatic.

If you - as an adorsys developer - need help [consult our wiki](https://github.com/adorsys/ops-adorsys-kubernetes-platform/wiki).

## :wrench: Available Tools
The following tools are available

* [external-dns](https://github.com/kubernetes-sigs/external-dns)  
  Managing all dns tasks for `adorsys.io`
* [nginx ingress](https://github.com/kubernetes/ingress-nginx)  
  Allowing public traffic inside the cluster
* [certmanager with lets-encrypt](https://github.com/cert-manager/cert-manager)  
  Providing x509 certs for secure access
* [argocd with gitlab & github access](https://github.com/argoproj/argo-cd)  
  Deploying the applications with GitOps
* [dex with azure as idp](https://github.com/dexidp/dex)  
  Access/Identity Management for loginrelated apps
* [external-secrets in aws-ssm](https://github.com/external-secrets/external-secrets)  
  Accessing sensitive Information inside the cluster

[docs]: https://github.com/adorsys/ops-kubernetes-as-an-adorsys-service/wiki
[page]: https://adorsys.com/en/services/devops-services/
[page-img]: https://img.shields.io/badge/www%20-adorsys.com-informational.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAC90lEQVRYhcWXS09TQRTHf70LWxRISYyiJuCrRHxUiSbqUpSNbvUDqN8A/QK6kISwNmpgoS7d+oqCrsCNAQ1GBBMxkoCWmFhaFghJXcwZ7jic3l4q4Ekm0/Oa/5lHZ/43QXypBy4A7cBRYDeQFt8v4CvwDngFPAEKqxg7UlqAPmAeKMVs80AvkPkX4BqgB1hUAKaBy45+BZhR4n4D3UBqteAZYFQGWQTuA4OifwJ2SpwFQmzjog9JzpLob4AdccHbgJwkjgMngQ7RC8A+J9YtwBZeEFsHcAqYEH0KyFYCzzjgL4FaIAGMiO2aF+8XAHBdbCOSWwv0O0U0lgOvIVz2p0BS7OfElmPlXmoFpJxJnBVbEnhOuB1JFOkhXPa0Y38o9ptKjlYAEluSXCtpwjNyw09oQT/t69UKeFvRt4Hgtt224PWEl8xhb2U6xX7HXzKRclsAcFd8nZ69VexFoC7AXK+bgbfABy/YFvS+DEiU2Bx/UmPAMLAFOB9g7naAR8ogB6T3C4sjo94Yrlis9gDzsIA+S3tQpqso4Lv02xSfxcoCzGL2pEkJzIsvrfgg+gykxZdXfE3i+5EAFoBNZQZZb1kI/hPwsgTAnPxuxtzdbrO+BsWXcMbRfA3im1N8zeLLB8CkKAeVAn9Kv7WKyW2XflbxHZL+S4ChUaA/lTnpY7/lSgE5xbf8zwswHA7gkhL4UXr/MokjdpZjiu+i9AMB8BhzFZ9QgOwFdKyKAtq8May0AscF85k19rLxj9E9t6oMhkBuFPgCsNdfsm7WnpA8cGwNhPywS8khhaFLJQx9WktKlgJeiG2QMpQMzN9tSgL7gTqqJ6XDotcBA2L7RgQptZJ1ipjAUGuXlu+PKKAFQzRKknMa+OyAH6kEbqWRcDuWMHs5RHhGtA+TXYR7PCQ5S45ecea+JDHs1c7IbTOYzzGrX8W8/9ppv0XEnseRRgyB1Aop14oYTrjir+ZLolKAI7UY/ngGczPu4e/P80nMYX2N+bApxhn0D4NAb2qf4dU3AAAAAElFTkSuQmCC

[apply-badge]: https://img.shields.io/github/actions/workflow/status/adorsys/ops-kubernetes-as-an-adorsys-service/apply.yml
[apply-url]: https://github.com/adorsys/ops-kubernetes-as-an-adorsys-service/actions/workflows/apply.yml
[license]: https://github.com/adorsys/ops-kubernetes-as-an-adorsys-service/blob/main/LICENSE.md
[license-img]: https://img.shields.io/badge/License-Apache%202.0-blue.svg
