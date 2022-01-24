1. Load and install the Grafana Helm chart, substituting your Ingress's hostname:

```sh
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade -i gfn grafana/grafana -f values.yaml --set ingress.hosts='{grafana.my.domain}' -n prometheus
```

2. Get the admin password:

```sh
kubectl get secret --namespace monitoring gfn-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

3. Go to the URL for your ingress hostname supplied, and login with admin / the password

4. Add a new Data Source, select Prometheus, call it exactly **Prometheus**

5. Set the Prometheus address to `http://pm-prometheus-server.prometheus.svc.cluster.local` and save it

6. Import the two dashboards in this directory

7. Done!
