# Kustomize Component

Kustomize is a popular packaging technology for Kubernetes applications. It relies on the series of patches. Hub can provide some additional templatng capabilities as well as some smarter resource creation capabilities

## Component Conventions

### Kustomize Detection

Because kustomize has been part of `kubectl -k ...` this compoenent doesn't require any specific configuration besides just a kubernetes. So hubfile should have 

```yaml
requires:
- kubernetes
```

Kustomize component has been detected by hub if component has following files in it's root directory:  `kustomization.yaml`, `kustomization.yaml.template` or `kustomization.yaml.gotemplate`

Then hub will be able detect this component as helm component and call provisioning script: [hub-component-kustomize](https://github.com/agilestacks/hub-extensions/blob/master/hub-component-kustomize)

### Input parameters

As every script, helm deployment scripts has been controlled via set off well-known environment variables. These variables should be defined in parameters section of `hub-component.yaml`. List of expected environment variables

| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `DOMAIN_NAME` | Hub will use a kubecontext that corresponds to FQDN of a stack | x |
| `NAMESPACE` | Target kubernetes namespace | x |
| `HUB_KUSTOMIZE_TARBALL_URL` | Download kustomize base from the tarball. It will unpack tarball into `<component root>/kustomize` directory. Then you can refer resources or bases from this directory in your `kustomization.yaml` file | |
| `HUB_KUSTOMIZE_TARBALL_SUBPATH` | Works in conjuction with `HUB_KUSTOMIZE_TARBALL_URL`, it instructs to unpack to the `<component root>/kustomize` a subpath inside the tarball | |

### Deployment hooks

User can define pre and post deployment

* `pre-deploy` to trigger action before helm install
* `post-deploy` to trigter action after successful helm install
* `pre-undeploy` to trigger action before helm delete
* `post-undeploy` to trigger action after helm successful delete

> Note: pre and post deployment scripts should have execution rights

### Custom Resources

We do advise not to deploy CRD with the helm chart. Because component `undeploy` (and `helm delete` correspondingly) will also delete CRDs. Deletion of CRD will also delete custom resources that may have been deployed by the user after this component has been deployed. Instead we advise to put your CRDs in to the  `<component root>/crds` directory. In this case, CRDs will be managed separately from the helm chart

1. CRDs will be deploymed before the helm chart
2. CRDs will not be deleted after component will be undeployed. Which means you can redeploy the component without dropping user custom resources

## Examples

## See also

* [Hub Components](hub-component.md)
