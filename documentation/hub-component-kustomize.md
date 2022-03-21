# Helm Component

Helm is a popular packaging technology for Kubernetes applications. We do provide our own opinionated way how to deploy helm components.

## Component Conventions

If component follows the conventions below, then hub will know how to deploy  it.

### Helm Detection

When you want to use helm deployment add the following definition to the `hub-component.yaml`

```yaml
requires:
- kubernetes
- helm
```

and place one one of the following files in the component directory:  `values.yaml`, `values.yaml.template` or `values.yaml.gotemplate`

Then hub will be able detect this component as helm component and call provisioning script: [helm-component-deploy](https://github.com/agilestacks/hub-extensions/blob/master/hub-component-helm-deploy) .

### Input parameters

As every script, helm deployment scripts has been controlled via set off well-known environment variables. These variables should be defined in parameters section of `hub-component.yaml`. List of expected environment variables

| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `DOMAIN_NAME` | Hub will use a kubecontext that corresponds to FQDN of a stack | x |
| `NAMESPACE` | Target kubernetes namespace | x |
| `COMPONENT_NAME` | Corresponds to parameter `hub.componentName` parameter, however can be overriden in `hub-component.yaml`. Hub will use this variable as a helm release name | x |
| `HELM_CHART` | This can have multiple values, that corresponds to the helm chart location. Corresponds to the helm chart tarball, directory or a chart name in the repository | x |
| `HELM_REPO` | Instructs hub to download helm chart from the helm repository | |
| `HELM_CHART_VERSION` | Addes a version constraint to the helm chart install. This variable works in conjunction with `HELM_REPO` | |
| `HELM_CHART_USERNAME` and `HELM_CHART_PASSWORD`| Username and password for helm chart repository basic auth | |
| `CHART_VALUES_FILE` | Instructs hub that it must use concrete values file inside of the helm chart as the base and only override with parameters from `values.yaml` in the component root directory` | |
| `HELM_OPTS` | Helm command arguments, defautls to `--create-namespace --wait` | |

#### Environment variable: `HELM_CHART`

Helm chart which user wants to deploy can be resolved via variable `HELM_CHART`. This variable corresponds to the following value:

* Path to the local directory with the helm chart (relative to the `<component root>` or `<component root>/charts` directory)
* Path to the local directory with the helm chart (relative to the `<component root>` or `<component root>/charts` directory )
* Name of the helm chart in the helm repository (requires user to define: `HELM_REPO` and `HELM_CHART_VERSION`)

### Deployment hooks

User can define pre and post deployment

* `pre-deploy` or `pre-deploy.sh` to trigger action before helm install
* `post-deploy` or `post-deploy.sh` to trigter action after successful helm install
* `pre-undeploy` or `pre-undeploy.sh` to trigger action before helm delete
* `post-undeploy` or `post-undeploy.sh` to trigger action after helm successful delete

> Note: pre and post deployment scripts should have execution rights

### Custom Resources

We do advise not to deploy CRD with the helm chart. Because component `undeploy` (and `helm delete` correspondingly) will also delete CRDs. Deletion of CRD will also delete custom resources that may have been deployed by the user after this component has been deployed. Instead we advise to put your CRDs in to the  `<component root>/crds` directory. In this case, CRDs will be managed separately from the helm chart

1. CRDs will be deploymed before the helm chart
2. CRDs will not be deleted after component will be undeployed. Which means you can redeploy the component without dropping user custom resources

## Examples

Nginx web server example. This is an example of a `hub-component.yaml` that will install a helm chart without any modifications. Complete code for nginx component can be found [here](https://github.com/agilestacks/components/tree/master/nginxing)

```yaml
kind: component
requires:
  - kubernetes
  - helm
parameters:
- name: dns.domain
  env: DOMAIN_NAME
- name: kubernetes.namespace
  value: kube-ingress
- name: helm.chart.name
  value: ingress-nginx
  env: HELM_CHART
- name: helm.chart.repo
  value: https://kubernetes.github.io/ingress-nginx
  env: HELM_REPO
- name: helm.chart.version
  value: 3.12.0
  env: HELM_CHART_VERSION
templates:
  files:
  - '*.template'
```

> Note: helm chart parameters values must be defined in the `values.yaml`, `values.yaml.template` or `values.yaml.gotemplate` file

## See also

* [Hub Components](hub-component.md)
