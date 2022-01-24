1. Add the Prometheus Community Helm charts:

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

2. Install Prometheus, with the configured mappings:

```sh
kubectl create namespace prometheus
helm install pm prometheus-community/prometheus -f values.yaml -n prometheus
```
