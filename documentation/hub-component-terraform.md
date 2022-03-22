# Terraform Component

Terraform is a popular infrastruture as code technology often used to deploy cloud resources. We do provide our own opinionated way how to deploy Terraform. In this case you can follow simple conventions and you don't require to write a deployment scripts

## Component Conventions

If component follows the conventions below, then hub will know how to deploy  it.

### Kustomize Detection

When you want to use helm deployment add the following definition to the `hub-component.yaml`

```yaml
requires:
- terraform
```

and place one one of the following files in the component directory:  `kustomization.yaml`, `kustomization.yaml.template` or `kustomization.yaml.gotemplate`

Then hub will be able detect this component as helm component and call provisioning script: [hub-component-kustomize](https://github.com/agilestacks/hub-extensions/blob/master/hub-component-kustomize) .

### Input parameters

As every script, helm deployment scripts has been controlled via set off well-known environment variables. These variables should be defined in parameters section of `hub-component.yaml`. List of expected environment variables

| Variable   | Description | Required | Passed from `.env`
| :-------- | :-------- | :-: | :--:
| `COMPONENT_NAME` | Corresponds to parameter `hub.componentName` parameter, however can be overriden in `hub-component.yaml`. Hub will use this variable as a helm release name | x | |
| `HUB_DOMAIN_NAME` | [FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name) of a stack. We use this parameter as a natural id of the deployment | x | x |
| `HUB_CLOUD_PROVIDER` | Tells hub to use different backends for terraform. We currently support: `aws`, `azure` or `gcp` | x | x |
| `HUB_STATE_BUCKET` | Object storage bucket to be be used for terraform state  | x | x |
| `HUB_STATE_REGION` | Region for terraform state bucket  | x | x |

There are additional environment variables, depends on your cloud type

### Terraform Variables

Terraform variables can be supplied in two ways:

1. Terraform variables can be defined in `*.tfvars` or `*.tfvars.template` file
2. Terraform variables can be defined by component parameter and exported as `TF_VAR_*` environment variable (recommended way)

#### AWS specific variables

These variables has been set during `hub stack configure` state and defined in `.env` file. You don't have to refer it for your component, however you can overwrite.

| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `AWS_PROFILE` | AWS name of the profile. Referenced from `.env` file. However you can override it in `hub-component.yaml` file | x |

#### Azure specific variables

These variables has been set during `hub stack configure` state and defined in `.env` file. These are the minimum viable variables expected by our terraform deploymenet script

| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `ARM_CLIENT_ID` | The client(application) ID of an App Registration in the tenant | |
| `ARM_CLIENT_SECRET` | A client secret that was generated for the App Registration | |
| `ARM_SUBSCRIPTION_ID` | Access an Azure subscription value from within a Terraform script | |
| `ARM_TENANT_ID` | ARM Tenant id | |

Full list of environment variables for azure can be found here: https://www.terraform.io/docs/language/settings/backends/azurerm.html

#### GCP specific variables


| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `GOOGLE_APPLICATION_CREDENTIALS` | Default applicaiton credentials (ADC) see details [here](https://cloud.google.com/docs/authentication/production) | |
| `GOOGLE_PROJECT` | For to refer google project ID. See details [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#full-reference) | |

Full reference of supported variables available here: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#full-reference

### Deployment hooks

User can define pre and post deployment

* `pre-deploy` to trigger action before helm install
* `post-deploy` to trigter action after successful helm install
* `pre-undeploy` to trigger action before helm delete
* `post-undeploy` to trigger action after helm successful delete

> Note: pre and post deployment scripts should have execution rights

## See also

* [Hub Components](hub-component.md)
* [Hub Component Helm](hub-component-helm.md)
* [Hub Component Kustomize](hub-component-kustomize.md)
