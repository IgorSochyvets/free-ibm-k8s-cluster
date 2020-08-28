# API key
variable "ibm_bmx_api_key" {
   default = ""
}

variable "region" {
   default = "us-south"
}

variable "resource_group" {
    default = ""
}

variable "kubernetes_cluster_name" {
    default = "free-k8s-cluster-aug-2020"
}

variable "zone" {
    default = "hou02"
}

variable "machine_type_default_worker" {
    default = "free"
}

variable "hardware" {
    default = "shared"
}

variable "kube_version" {
  description = "Version of K8S to use"
  type = string
  default = "1.17.11"
}