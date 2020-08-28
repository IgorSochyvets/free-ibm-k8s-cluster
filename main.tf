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
  datacenter        = var.zone
  default_pool_size = 1
  machine_type      = var.machine_type_default_worker
  hardware          = var.hardware
  kube_version      = var.kube_version
  resource_group_id  = data.ibm_resource_group.group.id
}


data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = ibm_container_cluster.k8s.name
  resource_group_id = data.ibm_resource_group.group.id
  depends_on = [ibm_container_cluster.k8s]
}

resource "null_resource" "install_cert-manager" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = <<LOCAL_EXEC
      export KUBECONFIG="${data.ibm_container_cluster_config.cluster_config.config_file_path}"
      # Install the CustomResourceDefinition resources separately
      kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml
      # Add the Jetstack Helm repository
      kubectl create namespace cert-manager
      helm repo add jetstack https://charts.jetstack.io
      helm repo update
      # Install the cert-manager Helm chart
      # Helm v3+
        helm install \
        cert-manager jetstack/cert-manager \
        --namespace cert-manager \
        --version v0.16.1 \
        --set ingressShim.defaultIssuerName=letsencrypt-prod \
        --set ingressShim.defaultIssuerKind=ClusterIssuer
      # Wait after install
      kubectl rollout status -w deployment/cert-manager-webhook --namespace=cert-manager
      kubectl wait --for=condition=Available --timeout=300s APIService v1beta1.webhook.cert-manager.io
      # Configuring Cluster Issuer
      kubectl apply -f clusterissuer.yaml
    LOCAL_EXEC
   }
}
