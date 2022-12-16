variable "cluster_name" {
  type = string
}

variable "dns_managed_zone" {
  type = string
}

variable "dns_domain_filters" {
  type = list(string)
}
