# Kong Helm Example
Sample hybrid Kong installation, using Helm.

## Repository Layout
This Helm chart has two directories, which correspond to two Helm installations: one for the control plane, one for the data plane.

## Required Infrastructure
It should install on any Kubernetes installation, however it is tested fully on two servers that are both running K3s.

You can install K3s for free from https://k3s.io

## Installation
The two stacks are test for installation with Helm v3.7.x - the installation for both is similar.

**You should install the control plane FIRST, because we create some certificates and secrets that are to be used in the data plane later...**

### Control Plane
- Change your `kubectl` context to the cluster that will run the **control plane** (example here):

```sh
kubectl config set-context kong-control-plane-cluster
```

- Create a control plane namespace and focus on it:

```sh
kubectl create namespace kong-control-plane
kubectl config set-context --current --namespace kong-control-plane
```

- Upload your Kong Enterprise license as a secret:

```sh
kubectl create secret generic kong-enterprise-license --from-file=license=<license_json_file_path>
```

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

- Create the session config secret:

```sh
echo '{"cookie_name":"admin_session","cookie_samesite":"off","secret":"admin-secret-CHANGEME","cookie_secure":true,"storage":"kong"}' > admin_gui.conf
echo '{"cookie_name":"portal_session","cookie_samesite":"off","secret":"portal-secret-CHANGEME","cookie_secure":true,"storage":"kong"}' > portal_gui.conf
kubectl create secret generic kong-session-config --from-file=admin_gui_session_conf=admin_gui.conf --from-file=portal_session_conf=portal_gui.conf
rm -f ./admin_gui.conf
rm -f ./portal_gui.conf
```

- Change directory to the control plane folder:

```sh
cd control-plane
```

- Add the Kong Helm repository and pull it:

```sh
helm repo add kong https://charts.konghq.com
helm repo update
```

- Construct a `values-override.yaml` file using the following template:

```yaml

```

- Install the control plane:

```sh
helm upgrade -i kong kong/kong -f values.yaml -f values-override.yaml
```
