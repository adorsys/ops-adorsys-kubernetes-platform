resource "helm_release" "postgres-operator" {
  chart = "postgres-operator"
  name  = "postgres-operator"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
  version = "1.8.2"
  namespace = var.namespace

  atomic = true
  cleanup_on_fail = true
  lint = true
  timeout = 70

  values = [
    <<YAML
configGeneral:
  min_instances: 1
  max_instances: 3
  workers: 4

configKubernetes:
  cluster_name_label: ${var.cluster_name}
  # We use EBS for storage
  enable_pod_antiaffinity: true
  pdb_name_format: "postgres-{cluster}-pdb"
  secret_name_template: "{username}.{cluster}.credentials.{tprkind}.{tprgroup}" #TODO
  # storage resize strategy, available options are: ebs, pvc, off
  storage_resize_mode: ebs

configLoadBalancer:
  db_hosted_zone: null

configAwsOrGcp:
  enable_ebs_gp3_migration: true

YAML
  ]
  depends_on = [kubernetes_manifest.ns]
}