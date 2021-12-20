# Kong Kubernetes Controller - Separate Workspaces

This example sets up two Kong Ingress Controllers, both watching different Kubernetes namespaces and creating resources in different Kong Workspaces.

## Installation

1. Create two namespaces that correspond to the same (or just similar) names as the desired Kong workspaces:

```sh
kubectl create namespace workspace1
kubectl create namespace workspace2
```

2. Change to the Kong **CONTROL PLANE** namespace:

```sh
kubectl config set-context --current --namespace kong-control-plane
```

2. Install the first ingress controller:

```sh
helm upgrade -i kong-ic-workspace1 kong/kong -f values-workspace1.yaml
```

3. Install the second ingress controller:

```sh
helm upgrade -i kong-ic-workspace2 kong/kong -f values-workspace2.yaml
```

Now you will see that if you create Kubernetes Ingress/Service/etcetera objects in Kube namespace "workspace1" and you'll see them appear in Kong workspace1.

The same happens for Kubernetes namespace "workspace2", they'll appear in Kong workspace2.
