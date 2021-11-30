# Kong Helm - Distributed Data Plane

This sample installs a complete Distributed Kong Enterprise, as the data plane role, including KIC.

## Installation

- Create a data plane namespace and focus on it:

```sh
kubectl create namespace kong-data-plane
kubectl config set-context --current --namespace kong-data-plane
```

- Upload the same Kong Enterprise license as a secret:

```sh
kubectl create secret generic kong-enterprise-license --from-file=license=<license_json_file_path>
```

- Install the data plane:

```sh
kubectl apply -f kong.yaml -n kong-data-plane
```
