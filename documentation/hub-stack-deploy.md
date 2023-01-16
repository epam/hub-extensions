# Command: `hubctl stack deploy`

Runs deployment for entire stack or updates deployment of one or few components

Component runlist order has been defined in hubfile. It looks like the following:

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
| `-c --component <component>` | Run deployment for one  component or multiple (supplied as comma separated value) | |
| `-o --offset <component>` | Start deployment from specific component (handy when you want to restart deployment, and want to skip few from the beginning in the runlist)  | |
| `-l --limit <component>` | Stop deployment after desired (opposite to `--offset` flag)  | |
| `--profile` | Choose a specific deployment provider (defaults to `HUB_PROFILE` in `.env` file)  | |
| `--tty` or `--no-tty` | Instructs if user wants to group deployment outputs per component | |

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |

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
| :-------- | :-------- | :-: | :-: |
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
| :-------- | :-------- |
| `before-deploy` | Executed before deployment operation, fail with error code non 0 to stop deployment from happening |
| `after-deploy` | Executed before deployment operation, fail with error code non 0 to mark deployment as failed. Useful when you apply some deployment tests |
| `before-undeploy` | Executed before un-deployment operation, fail with error code non 0 to stop un-deployment from happening |
| `after-undeploy` | Executed before un-deployment operation, fail with error code non 0. Useful if you want to check that all resources has been deleted and grab user attention on some cloud junk |

## Deployment Profiles

There are few ways how to run a deployment, It primarilly depends on if this is a desire of the user where they want to have all desired provisioning tools setup and keep updated periodically. User also might  want to run deployment from CI server etc. This is why we have got different deployment profiles

Deployment profile has been configured in `.env` file via environment variable `HUB_DEPLOY_PROFILE`. This variable has been set during the `configure` time, but can be changed by editing `.env` file

### Deployment profile: `local`

This profile has been preferable when user wants to run all automation from their local workstation. User also have got all provisioning tools required by the stack (such as `terraform`, `helm` or `kustomize`) installed locally. This profile gives fastest feedback if something goes wrong and direct tools to troubleshoot

### Deployment profile: `toolbox`

If you have a docker locally then you may not want to install all provisioning tools. Instead `toolbox` profile will run a special Docker container with all tools installed and then mount your working diretory inside. This deployment profile is handy to work in a team and  address __works on my workstation__ issues as every team member will work with exactly the same toolchain that comes with toolbox container


### Deployment profile: `pod`

This is evolution of a toolbox profile. Instead, if you have a Kubernetes cluster at your disposal, you may want to run an automation task as a Kubernetes native pod. This pod will do the following

1. Run a `toolbox` container in a Kubernetes namespace `automation-tasks`
2. Copy a working directory inside of a `pod`
3. Copy credentials such as `aws` or `kubernetes`
4. Run automation task
5. Collect the result and store locally state
6. Shut down the container

### DYI Deployment profile

If you want to build your own deployment profile, then put a script into the `.hub/profiles/<profile-name>` directory and add execution rights. Then update environment vaiable `HUB_DEPLOY_PROFILE` in the `.env`

## Usage Example

To deploy all components in the runlist:

```bash
hubctl stack deploy
```

To deploy specific components with order defined in the runlist

```bash
hubctl stack deploy -c "external-dns,cert-manager"
```


## See also

* [`hubctl stack undeploy`](hub-stack-undeploy.md)
* [`hubctl stack configure`](hub-stack-configure.md)
* [`hubctl stack init`](hub-stack-init.md)
