# Kong Helm - AIO Example with Ingress Routes

This sample installs a complete all-in-one Kong Enterprise instance, but it adds Ingress routes.

## Installation
- Create a data plane namespace and focus on it:

```sh
kubectl create namespace kong-data-plane
kubectl config set-context --current --namespace kong-data-plane
```

- Upload your Kong Enterprise license as a secret:

```sh
kubectl create secret generic kong-enterprise-license --from-file=license=<license_json_file_path>
```

- Create the cluster certificates as a secret:

```sh
kubectl create secret tls kong-cluster-cert --cert=$(pwd)/../aio-with-ingress-cp/cluster-certs/cluster.crt --key=$(pwd)/../aio-with-ingress-cp/cluster-certs/cluster.key
```

- Add the Kong Helm repository and pull it:

```sh
helm repo add kong https://charts.konghq.com
helm repo update
```

- Install the data plane:

```sh
helm upgrade -i kong kong/kong -f values.yaml
```
