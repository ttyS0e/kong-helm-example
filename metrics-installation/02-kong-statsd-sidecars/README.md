1. Create the statsd mapping configmap in the Kong **data planes** namespace:

```sh
kubectl apply -f statsd-configmap-standalone.yaml -n kong-data-plane
```

2. Add a statsd sidecar to all Kong **data plane** containers, by adding the Helm values:

```yaml
deployment:
  sidecarContainers:
  - name: statsd-exporter
    image: prom/statsd-exporter:v0.20.1
    args:
    - "--statsd.mapping-config=/data/statsd-mapping.yml"
    ports:
    - name: kong
      containerPort: 9125
    - name: prometheus
      containerPort: 9102
    volumeMounts:
    - mountPath: /data
      name: statsd-mapping

extraConfigMaps:
- name: statsd-mapping
  mountPath: /data
```

3. Add the Prometheus scrape annotations to all Kong **data plane** pods, by adding the Helm values:

```yaml
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/path: /metrics
  prometheus.io/scheme: "http"
```

4. Add the Prometheus and stats config to **all nodes** (control plane and data planes) Helm values:

```yaml
env:
  vitals_strategy: prometheus
  vitals_statsd_address: 127.0.0.1:9125
  vitals_tsdb_address: pm-prometheus-server.prometheus.svc.cluster.local:80
  vitals_prometheus_scrape_interval: 10
```

5. Apply the Kong control plane and data plane Helm configuration with Helm, as normal.
