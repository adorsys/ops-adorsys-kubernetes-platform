resource "helm_release" "dex" {
  chart      = "dex"
  name       = "dex"
  repository = "https://charts.dexidp.io"
  version    = "0.14.2"
  namespace  = "ops-dex"

  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 70

  values = [
    <<YAML
envFrom:
 - secretRef:
     name: dex-azure-ad-connector
 - secretRef:
     name: dex-argocd
replicaCount: 2
https:
  enabled: false
ingress:
  enabled: true
  className: nginx
  annotations:
    kubernetes.io/tls-acme: "true"
  hosts:
    - host: login.${var.cluster_name}.adorsys.io
      paths:
        - path: /
          pathType: Prefix
  tls:
    - hosts:
      - login.${var.cluster_name}.adorsys.io
      secretName: dex-cert
config:
  issuer: https://login.${var.cluster_name}.adorsys.io/dex/
  storage:
    type: kubernetes
    config:
      inCluster: true
  web:
    http: 0.0.0.0:5556
  telemetry:
    http: 0.0.0.0:5558
  staticClients:
  - name: Argocd
    IDEnv: client-id
    secretEnv: client-secret
    redirectURIs:
    -  https://argocd.${var.cluster_name}.adorsys.io/auth/callback
  connectors:
  - type: microsoft
    id: microsoft
    name: Microsoft
    config:
      clientID: $MICROSOFT_CLIENT_ID
      clientSecret: $MICROSOFT_CLIENT_SECRET
      redirectURI: https://login.${var.cluster_name}.adorsys.io/dex/callback
      loadAllGroups: false
  enablePasswordDB: false
YAML
  ]
  depends_on = [kubernetes_manifest.ns]
}

