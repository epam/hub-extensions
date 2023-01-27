# Command: `hubctl stack`

Helps you to manage your stack deployments

## Useful Commands

Extensions provides following commands:

| Command   | Description
| --------- | ---------
| [`hubctl stack init`](hub-stack-init.md) | Initialise a new stack deployment in the working directory |
| [`hubctl stack configure`](hub-stack-configure.md) | Manage configuration before the deployment |
| [`hubctl stack deploy`](hub-stack-deploy.md) | Apply deployment to target infrastructure |
| [`hubctl stack undeploy`](hub-stack-undeploy.md) | Reverse deployment action |
| [`hubctl stack ls`](hub-stack-ls.md) | See other stacks that has been initialized for the working directory |
| [`hubctl stack set`](hub-stack-set.md) | Change a different current stack |
| [`hubctl stack unconfigure`](hub-stack-uncfonfigure.md) | Delete configuration of a stack from working directory. This commands is irreversive, and __doesn't run [`undeploy`](hub-stack-undeploy.md)__

## Advanced Commands

These commands intended for advanced usage

| Command   | Description
| --------- | ---------
| `hubctl stack backup <subcommand>` | Stack backup/restore management (*if "backup" verb supported by at least one component in the stack)|
| `hubctl stack elaborate` | Reconcile defined parameters and a state |
| `hubctl stack deploy` | Apply deployment to target infrastructure |
| `hubctl stack invoke verb>` | Execute other verb rather than `deploy`, `undeploy` or `backup`. (*if verb supported by at least one component in the stack)|
| `hubctl stack explain` | Command reserved for state and parameters diagnostics |

## Usage examples

Deploy a new GKE cluster with External DNS

```bash
hubctl stack init \
    -f "https://raw.githubusercontent.com/epam/hub-google-stacks/main/gke-empty-cluster/hub.yaml"
hubctl stack configure
hubctl stack deploy
```

Undeploy stack deployed by someone else

```bash
hubctl stack init \
    -f "https://raw.githubusercontent.com/epam/hub-google-stacks/main/gke-empty-cluster/hub.yaml" \
    -s "gs://<gs path to the state file>"
hubctl stack configure
hubctl stack undeploy
```

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |

