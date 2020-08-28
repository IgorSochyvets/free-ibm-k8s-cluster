# free-ibm-k8s-cluster
Configuration for IBM Schematics (Terraform as a Service) for free k8s cluster deployment in IBM Cloud

#### Free IBM Kubernetes cluster deployment
see `main.tf` file

#### Certmanager deployment
```
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml

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

kubectl apply -f clusterissuer.yaml
```
#### Nginx Ingress Controller deployment

```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

kubectl create ns nginx-ingress

helm upgrade --install nginx-ingress  \
    --namespace=nginx-ingress \
    --set hostNetwork=true \
    --set controller.service.enabled=false \
    --set controller.kind=DaemonSet \
    --set controller.daemonset.useHostPort=true \
    --version v1.41.3 \
    stable/nginx-ingress
```
