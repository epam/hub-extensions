# Hub Extensions

By default `hub` is a CLI tool that provides a fine arguments that takes are flexible
but takes some patient learning to master. Extensions is a collection of wrapper scripts
to provide more streamlines user experience and `hub` best practices

## Useful Commands

Extensions provides following commands:

| Command   | Description
| --------- | ---------
| [`hub stack <subcommand>`](hub-stack.md) | Commands to manage your deployment |
| [`hub show`](hub-show.md) | Show parameters of a deployed stack |
| [`hub toolbox`](hub-toolbox.md) | Starts a local toolbox container and mounts current file system inside |

## Free form component

Free form component provides maximum flexibility. There are no specific extension for that. However it will help to understand principles behind component specific extensions

| Command   | Description | Selected when |
| --------- | ----------- | --------- |
| [`hub compoent`](hub-component.md) | Free form component. Can use any provisionoing tool or technology. Only one limietation, this tool must be delivered inside a toolbox (custom image ok) or be intalled on your workstation | `deploy` and `undeploy` or `deploy.sh` and `undeploy.sh` |

## Extensions for Component provisioning

Extensions can also provide an opinionated way on how to deploy a component using concrete technology

| Command   | Description | Selected when |
| --------- | ----------- | --------- |
| [`hub compoent terraform`](hub-component-terraform.md) | Deploys component using terraform | `*.tf` |
| [`hub compoent helm`](hub-component-helm.md) | Deploys component with helm chart | `values.yaml` |
| [`hub compoent kustomize`](hub-component-kustomize.md)| Deploys component with kustomize | `kustomization.yaml` |
