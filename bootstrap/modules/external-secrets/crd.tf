resource "kubectl_manifest" "cluster_secret_store" {
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: aws-ssm
spec:
  provider:
    aws:
      service: SecretsManager
      role: ${aws_iam_role.assume_role.arn}
      region: eu-central-1
      auth:
        secretRef:
          accessKeyIDSecretRef:
            name: external-secrets
            key: access_key_id
            namespace: ${kubernetes_manifest.ns.manifest.metadata.name}
          secretAccessKeySecretRef:
            name: external-secrets
            key: secret_access_key
            namespace: ${kubernetes_manifest.ns.manifest.metadata.name}
YAML
  depends_on = [helm_release.external_secrets]
}

resource "kubectl_manifest" "external_cluster_secret" {
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterExternalSecret
metadata:
  name: "gitlab-image-pull-secret"
spec:
  externalSecretName: "gitlab"
  namespaceSelector:
    matchLabels:
      git-engine: gitlab
  refreshTime: "1m"
  externalSecretSpec:
    secretStoreRef:
      name: aws-ssm
      kind: ClusterSecretStore
    refreshInterval: "1h"
    target:
      name: gitlab
      creationPolicy: 'Merge'
      template:
        type: kubernetes.io/dockerconfigjson
        metadata:
          annotations: {}
          labels: {}
        data:
          .dockerconfigjson: "{{ .dockerconfig | toString }}"
      creationPolicy: Owner
    data:
    - secretKey: dockerconfig
      remoteRef:
        key: kaas/clusterwide-sharedsecrets/gitlab-image-pull-secret
YAML
  depends_on = [helm_release.external_secrets]
}
