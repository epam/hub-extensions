# ARM Deployment Template

ARM templates are used to deploy resources to Azure. They are written in JSON and can be used to deploy a single resource or a set of resources. They can be used to deploy resources to a new resource group or to an existing resource group. They can be used to deploy resources to a new subscription or to an existing subscription.

Hubctl can deploy ARM templates as a component. Hubctl will use the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) to deploy the ARM template.

## ARM Conventions

To enable hubctl to recognize component as an ARM deployment component, User should add `arm` requirements to `hub-component.yaml` file:

```yaml
requires:
- azure
- arm
```

### Input parameters

There are number of well-known parameters that can be used to configure ARM deployment. These parameters are defined in `hub-component.yaml` file. Today there is no strict convention for parameter names. User is free to choose any parameter name they like, however these parameters should be bound to the specific environment variables.

| Variable   | Description | Required | Passed from `.env`
| :-------- | :-------- | :-: | :--:
| `ARM_TEMPLATE` | Local file or URI to the ARM Deployment Template. If not set then hubctl will try to find deployment template by schema in component directory | | |
| `ARM_DEPLOYMENT_NAME` | Name associated to the ARM Deployment. If not set then name of the component will be used | | |
| `ARM_PARAMETER_FILES` | Space separated list to ARM Deployment Parameter files. If file cannot be found it will be ignored | | |
| `ARM_PARAMETER_paramName` | Hubctl will read all environment variables prefixed with `ARM_PARAMETERS_` to set ARM deployment parameters. In this example hubctl will set a parameter `parameterName` with the value of environment variable `ARN_PARAMETER_paramName` | | |
| `ARM_PARAM_paramName` | Same as `ARM_PARAMETER_paramName` | | |
| `AZURE_RESOURCE_GROUP_NAME` | Name of the target resource group. If not set then resource group defined during `hub stack configure -r "azure"` will be used | | |

> Note: `ARM_PARAMETER_` and `ARM_PARAM_` are aliases for the same parameter. User can use either one of them. These environment variables works similar to well known Terraform variables `TF_VAR_`.

### Deployment Hooks

* `pre-deploy` to trigger action before ARM Deployment template will be created
* `post-deploy` to trigger action after ARM Deployment template will be created
* `pre-undeploy` to trigger action before ARM Deployment template will be deleted
* `post-undeploy` to trigger action before ARM Deployment template will be deleted

> Note: pre and post deployment scripts should have execution rights

## See also

* [Hub Components](hub-component.md)
* [Hub Component Terraform](hub-component-terraform.md)
