# Kong Helm - Distributed Control Plane

This sample installs a complete Distributed Kong Enterprise, as the control plane role, including KIC.

## Installation

- Create a control plane namespace and focus on it:

```sh
kubectl create namespace kong-control-plane
kubectl config set-context --current --namespace kong-control-plane
```

- Upload your Kong Enterprise license as a secret:

```sh
kubectl create secret generic kong-enterprise-license --from-file=license=<license_json_file_path>
```

- Create the super admin password secret:

```sh
kubectl create secret generic kong-enterprise-superuser-password --from-literal=password=secure-password-here
```

- Create the session configs:

```sh
echo '{"cookie_domain":".k3s.local","cookie_name":"admin_session","cookie_samesite":"off","secret":"admin-secret","cookie_secure":false,"storage":"kong"}' > admin_gui.conf
echo '{"cookie_domain":".k3s.local","cookie_name":"portal_session","cookie_samesite":"off","secret":"portal-secret","cookie_secure":false,"storage":"kong"}' > portal_gui.conf
kubectl create secret generic kong-session-config --from-file=admin_gui_session_conf=admin_gui.conf --from-file=portal_session_conf=portal_gui.conf
rm -f ./admin_gui.conf
rm -f ./portal_gui.conf
```

- Install the control plane:

```sh
kubectl apply -f kong.yaml -n kong-control-plane
```
