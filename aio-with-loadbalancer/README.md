# Kong Helm - AIO Example

This sample installs a complete all-in-one Kong Enterprise instance, using the default built-in certificates.

## Required Infrastructure
It should install on any Kubernetes installation, however it is tested fully on two servers that are both running K3s.

You can install K3s for free from https://k3s.io

## Installation
This is tested with Helm v3.7.x.

- Install the AIO instance:

```sh
helm upgrade -i kong kong/kong -f values.yaml
```
