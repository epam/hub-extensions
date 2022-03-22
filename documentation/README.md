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

## Extensions for Component provisioning

Extensions can be also used by the components automatically.

| Command   | Description | Selected when |
| --------- | ----------- | --------- |
| [`hub compoent terraform`](hub-component-terraform.md) | Deploys component using terraform | `*.tf` |
| [`hub compoent helm`](hub-component-helm.md) | Deploys component with helm chart | `values.yaml` |
| [`hub compoent kustomize`](hub-component-kustomize.md)| Deploys component with kustomize | `kustomization.yaml` |
