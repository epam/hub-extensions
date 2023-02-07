# Kubernetes Component

Kubenretes is a far popular technology to run containers. We do love Kubernetes and provide  first class support with the `hub`. So `hub` will manage access credentials and provide naming conventions for Kubernetes.

## When component requires kubenretes

Here we provide conventions required for component if it requires kubenretes. These conventions repeat conventions for [helm extensions](hub-component-helm.md) and [kustomize extensions](hub-component-kustomize.md)

File `hub-component.yaml` of the component should require `kubernetes` and expose few of the parameters as the environment variabels

```yaml
requires:
- kubernetes
parameters:
- name: dns.domain
  env: HUB_DOMAIN_NAME
- name: kubernetes.namespace # this parameter name can be anything
  value: kube-system         # this is example of kubenretes namespace
  env: NAMESPACE
```

More about required parameters has been described below

> Note: kubeconfig should exist before, kubernetes cluster context should match to the `dns.domain` of your stack

### Input parameters

As every script, helm deployment scripts has been controlled via set off well-known environment variables. These variables should be defined in parameters section of `hub-component.yaml`. List of expected environment variables

| Variable   | Description | Required | Passed from `.env`
| :-------- | :-------- | :-: | :--:
| `HUB_DOMAIN_NAME` | Hub naming convention requires `dns.domain` parameter to match to kubeconfig context that corresponds to the stack, fallbacks to legacy `DOMAIN_NAME` env var. If not defined in `hub-component.yaml` manifest will be derived from stack | x |
| `NAMESPACE` | Target kubernetes namespace | x |

There are additional environment variables, depends on your cloud type

### Kubeconfig helper script

Because components de-facto has been deployed by the shell scripts. So it is natural to provide helper functionality for Kubernetes in the form of script as well.

`bin/kubeconfig` is a script that helps with kubeconfig management. This sript has been available in the `PATH` of every component that has been deployed.

* `kubeconfig cp` - writes to stdout (or file) the extracted copy of a one context and user credentials. It will rename to the value of (`HUB_STACK_DOMAIN`) to follow to the `hub` conventions for kubernetes.
* `kubeconfig test` - will test connectivity to the kubernetes cluster

## When component provides kubenretes

This is useful when component actually deploys a new instance of the Kubenretes cluster. Then the component has been responsible to provide outputs of a kubenretes cluster in a standard form (standard output parameters and kubeconfig). So, this can be used by following components in the runlist that __requires kubernetes__. This is a bit of extra effort but it will also ensure that component that requires kubernetes (and possible written by someone else) will know how to get deployed into the Kubenretes cluster providen by your component

There are various ways how Kubenretes cluster can be deployed. So, information in the `hub-component.yaml` file will be different

### Example for `GKE`

The minimalistic GKE cluster should provide following

```yaml
provides:
- kubernetes
outputs:
  - name: dns.domain
  - name: kubernetes.gke.cluster
  - name: kubernetes.api.endpoint
```

## See also

* [Hub Components](hub-component.md)
* [Hub Component Helm](hub-component-helm.md)
* [Hub Component Kustomize](hub-component-kustomize.md)
