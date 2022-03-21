# Command: `hub stack undeploy`

Runs a reversive to un-deployment for operation for entire stack or one component

Order in which components will be un-deployed is the reversive order to the one defined in the hubfile

```yaml
lifecycle:
  order:
  - component1
  - component2
  # ...
  - componentN
```

Because `undeploy` is a reversive operation to `deploy`, you might want to check out article for [`hub stack deploy`](hub-stack-deploy.md) sections about __deployment profiles__ and __deployment hooks__.

## Command Parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-c --component <component>` | Start un-deployment for one  component or multiple (supplied as comma separated value) | |
| `-o --offset <component>` | Start un-deployment from specific component (handy when you want to restart un-deployment, and want to skip few from the beginning in the runlist)  | |
| `-l --limit <component>` | Stop un-deployment after desired (opposite to `--offset` flag)  | |
| `--profile` | Choose a specific un-deployment provider (defaults to `HUB_PROFILE` in `.env` file)  | |
| `--tty` <br> or `--no-tty` | Instructs if user wants to group outputs per component ]

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |

## Usage Example

To un-deploy all components in the runlist:

```bash
hub stack undeploy
```

To un-deploy specific components with order defined in the runlist

```bash
hub stack undeploy -c "external-dns,cert-manager"
```


## See also

* [`hub stack deploy`](hub-stack-deploy.md)
* [`hub stack init`](hub-stack-init.md)
* [`hub stack configure`](hub-stack-configure.md)
