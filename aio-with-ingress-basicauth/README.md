# Kong Helm - AIO Example with Ingress Routes

This sample installs a complete all-in-one Kong Enterprise instance, but it adds Ingress routes.

## Installation
- Create the session confs:

```sh
echo '{"cookie_domain":".k3s.local","cookie_name":"admin_session","cookie_samesite":"off","secret":"admin-secret","cookie_secure":false,"storage":"kong"}' > admin_gui.conf
echo '{"cookie_domain":".k3s.local","cookie_name":"portal_session","cookie_samesite":"off","secret":"portal-secret","cookie_secure":false,"storage":"kong"}' > portal_gui.conf
kubectl create secret generic kong-session-config --from-file=admin_gui_session_conf=admin_gui.conf --from-file=portal_session_conf=portal_gui.conf
rm -f ./admin_gui.conf
rm -f ./portal_gui.conf
```

- Install over the top of the AIO instance:

```sh
helm upgrade -i kong kong/kong -f values.yaml
```
