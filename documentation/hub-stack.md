# Command: hub stack

Helps you to manage your stack deployments

## Useful Commands

Extensions provides following commands:

| Command   | Description
| --------- | ---------
| [`hub stack init`](hub-stack-init.md) | Initialize a new stack deployment in the working directory |
| [`hub stack configure`](hub-stack-configure.md) | Manage configuration before the deployment |
| [`hub stack deploy`](hub-stack-deploy.md) | Apply deployment to target infrastructure |
| [`hub stack undeploy`](hub-stack-undeploy.md) | Reverse deployment action |
| [`hub stack ls`](hub-stack-ls.md) | See other stacks that has been initialized for working directory |
| [`hub stack set`](hub-stack-set.md) | Change a different current stack |
| [`hub stack unconfigure`](hub-stack-uncfonfigure.md) | Delete configuration of a stack from working directory. This commands is irreversive, and __doesn't run `undeploy`__

## Advanced Commands

These commands intended for advanced usage

| Command   | Description
| --------- | ---------
| `hub stack backup <subcommand>` | Stack backup/restore management (*if "backup" verb supported by at least one component in the stack)|
| `hub stack elaborate` | Reconsile defined parameters and a state |
| `hub stack deploy` | Apply deployment to target infrastructure |
| `hub stack invoke verb>` | Execute other verb rather than `deploy`, `undeploy` or `backup`. (*if verb supported by at least one component in the stack)|
| `hub stack explain` | Command reserved for state and parameters diagnostics |

## Usage examples

Deploy a new GKE cluster with External DNS

```bash
hub stack init \
    -f "https://raw.githubusercontent.com/agilestacks/google-stacks/main/hub-just-gke.yaml"
hub stack configure
hub stack deploy
```

Undeploy stack deployed by someone else

```bash
hub stack init \
    -f "https://raw.githubusercontent.com/agilestacks/google-stacks/main/hub-just-gke.yaml" \
    -s "gs://<gs path to the state file>"
hub stack configure
hub stack undeploy
```
