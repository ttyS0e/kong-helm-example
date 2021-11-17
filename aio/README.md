# Kong Helm - AIO Example

This sample installs a complete all-in-one Kong Enterprise instance, using the default built-in certificates.

## Required Infrastructure
It should install on any Kubernetes installation, however it is tested fully on two servers that are both running K3s.

You can install K3s for free from https://k3s.io

## Installation
This is tested with Helm v3.7.x.

- Create a control plane namespace and focus on it:

```sh
kubectl create namespace kong-control-plane
kubectl config set-context --current --namespace kong-control-plane
```

- Upload your Kong Enterprise license as a secret:

```sh
kubectl create secret generic kong-enterprise-license --from-file=license=<license_json_file_path>
```

- Add the Kong Helm repository and pull it:

```sh
helm repo add kong https://charts.konghq.com
helm repo update
```

- Install the AIO instance:

```sh
helm upgrade -i kong kong/kong -f values.yaml
```
