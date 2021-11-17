# Kong Helm - AIO Example with Ingress Routes

This sample installs a complete all-in-one Kong Enterprise instance, but it adds Ingress routes.

## Installation
- Install over the top of the AIO instance:

```sh
helm upgrade -i kong kong/kong -f values.yaml
```
