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
