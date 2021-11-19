# Kong Helm - Distributed Data Plane

This sample installs a complete Distributed Kong Enterprise, as the data plane role.

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

- Set the correct database URL in `values.yaml`:

```yaml
env:
  database: postgres
  pg_user: kong
  pg_password: kong
  pg_database: kong
  pg_host: kong-cp-postgresql.kong-control-plane.svc.cluster.local  # point to the control plane postgres, assuming it's already created
```

- Install the data plane:

```sh
helm upgrade -i kong-dp kong/kong -f values.yaml
```
