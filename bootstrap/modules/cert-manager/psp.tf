resource "kubectl_manifest" "secret" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
 name: letsencrypt
spec:
 acme:
   server: https://acme-v02.api.letsencrypt.org/directory
   email: devops@adorsys.com
   privateKeySecretRef:
     name: letsencrypt
   solvers:
   - http01:
       ingress:
         class: nginx
YAML
}