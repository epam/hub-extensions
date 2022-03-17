# Command: hub stack deploy

Runs deployment for entire stack or updates deployment of one or few components

Order in which components has been deployed has been defined in the hubfile

```yaml
lifecycle:
  order:
  - component1
  - component2
  # ...
  - componentN
```

## Command Parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-c | --component <component>` | Run deployment for one  component or multiple (supplied as comma separated value) | |
| `-o | --offset <component>` | Start deployment from specific component (handy when you want to restart deployment, and want to skip few from the beginning in the runlist)  | |
| `-l | --limit <component>` | Stop deployment after desired (opposite to `--offset` flag)  | |
| `--profile` | Choose a specific deployment provider (defaults to `HUB_PROFILE` in `.env` file)  | |
| `--tty` or `--no-tty` | Instructs if user wants to group deployment outputs per component ]

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V | --verbose` | extra verbosity for diagnostics | |
| `-h | --help` | print help and usage message | |

## Advanced usage

### Hooks for before-deployment and after-deployment

It is possible if user will decide to add one or more deployment hooks. This hooks will be executed before or after the deployment has been done.

These deployment hooks has been defined via hubfile

```yaml
extensions:
  deploy:
    before:
    - <extension>
    after:
    - <extension>
```

example:

```yaml
extensions:
  deploy:
    before:
    - kubernetes
    after:
    - inventory-configmap
```

Example above will run a kubernetes extension before the deployment to check connectivity to the desired cluster. It will also instruct a `hub` to save deployment state inside of the kubenretes cluster as a `configmap`. This is viable alternative to the object storage and can be handy to store copy of a state for on-prem deployments.

At the moment there are few extensions that supports before deployment or after deployemnt

| Extension  | Description | Before | After |
| :-------- | | :-------- | :-: | :-: |
| `kubernetes` | Checks connectivity to existing kubernetes cluster before actual deployment (helps with deployment success rate) | x | x |
| `aws-metering` | Provides integration to aws marketplace metering | x | |
| `inventory-configmap` | Save a copy of a deployment state in the configmap of a kubernetes cluster. Adds some extra persistence for on-prem deployments as they might not have object storage bucket access to store state there | | x |

### DYI deployment hook

Q: Can I add my own deployment hook?
A: Yes, easy!

1. Create a file in the `.hub/<extension>/before-deploy` and add execution rights
2. Implement hook using shell (preferably), bash, or language of your choice

Q: Which shell hooks I can build?
A: Make sure you follow the naming convention for file name

| Script | Description |
| :-------- | | :-------- |
| `before-deploy` | Executed before deployment operation, fail with error code non 0 to stop deployment from happening |
| `after-deploy` | Executed before deployment operation, fail with error code non 0 to mark deployment as failed. Useful when you apply some deployment tests |
| `before-undeploy` | Executed before un-deployment operation, fail with error code non 0 to stop un-deployment from happening |
| `after-undeploy` | Executed before un-deployment operation, fail with error code non 0. Useful if you want to check that all resources has been deleted and grab user attention on some cloud junk |

## Usage Example

To deploy all components in the runlist:

```bash
hub stack deploy
```

To deploy specific components with order defined in the runlist

```bash
hub stack deploy -c "external-dns,cert-manager"
```


## See also

* [`hub stack init`](hub-stack-init.md)
* [`hub stack configure`](hub-stack-configure.md)
* [`hub stack undeploy`](hub-stack-undeploy.md)
