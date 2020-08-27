provider "ibm" {
  ibmcloud_api_key = var.ibm_bmx_api_key
  region           = var.region
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}

##### K8S Cluster #######
#  Creating 1 worker node on default pool

resource "ibm_container_cluster" "k8s" {
  name              = var.kubernetes_cluster_name
  datacenter        = var.subnets[0].zone
  default_pool_size = 1
  machine_type      = var.machine_type_default_worker
  hardware          = var.hardware
  
  public_vlan_id    = var.subnets[0].public_vlan_id
  private_vlan_id   = var.subnets[0].private_vlan_id

  kube_version      = var.kube_version

  public_service_endpoint  = true
  private_service_endpoint = true

  resource_group_id  = var.resource_group_id
}


data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = ibm_container_cluster.k8s.name
  resource_group_id = var.resource_group_id
  depends_on = [ibm_container_cluster.k8s]
}
