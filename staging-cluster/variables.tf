variable "cluster_name" {
  type        = string
  description = "The commonly refered name of the cluster"

  default = "staging"
}

variable "cluster_id" {
  type        = string
  description = "The kubermatic cluster id (not mixed up with the project_id)"

  default = "7cdrqrfvvs"
}

variable "cluster_port" {
  type        = string
  description = "The kubermatic cluster port"

  default = "30291"
}
