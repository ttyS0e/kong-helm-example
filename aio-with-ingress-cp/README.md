# Kong Helm - AIO Example with Ingress Routes

This sample installs a complete all-in-one Kong Enterprise instance, but it adds Ingress routes.

## Installation

- Generate cluster certificates:

```sh
mkdir ./cluster-certs/
openssl req -new -x509 -nodes -newkey ec:<(openssl ecparam -name secp384r1) \
  -keyout ./cluster-certs/cluster.key -out ./cluster-certs/cluster.crt \
  -days 1095 -subj "/CN=kong_clustering"
```

- Create the cluster certificates as a secret:

```sh
kubectl create secret tls kong-cluster-cert --cert=$(pwd)/cluster-certs/cluster.crt --key=$(pwd)/cluster-certs//cluster.key
```

- Install over the top of the AIO instance:

```sh
helm upgrade -i kong kong/kong -f values.yaml
```
