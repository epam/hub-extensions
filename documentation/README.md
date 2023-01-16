# Hub Extensions

By default `hub` is a CLI tool that provides a fine arguments that takes are flexible
but takes some patient learning to master. Extensions is a collection of wrapper scripts
to provide more streamlines user experience and `hub` best practices

## Useful Commands

Extensions provides following commands:

| Command   | Description
| --------- | ---------
| [`hubctl stack <subcommand>`](hub-stack.md) | Commands to manage your deployment |
| [`hubctl show`](hub-show.md) | Show parameters of a deployed stack |
| [`hubctl toolbox`](hub-toolbox.md) | Starts a local toolbox container and mounts current file system inside |
| [`hubctl state`](hub-state.md) | Helps you to manage stacks states |

## Free form component

Free form component provides maximum flexibility. There are no specific extension for that. However it will help to understand principles behind component specific extensions

| Command   | Description | Selected when |
| --------- | ----------- | --------- |
| [`hubctl compoent`](hub-component.md) | Free form component. Can use any provisionoing tool or technology. Only one limietation, this tool must be delivered inside a toolbox (custom image ok) or be intalled on your workstation | `deploy` and `undeploy` or `deploy.sh` and `undeploy.sh` |

## Extensions for Component provisioning

Extensions can also provide an opinionated way on how to deploy a component using concrete technology

| Command   | Description | Selected when |
| --------- | ----------- | --------- |
| [`hubctl compoent terraform`](hub-component-terraform.md) | Deploys component using terraform | `*.tf` |
| [`hubctl compoent helm`](hub-component-helm.md) | Deploys component with helm chart | `values.yaml` |
| [`hubctl compoent kustomize`](hub-component-kustomize.md)| Deploys component with kustomize | `kustomization.yaml` |
