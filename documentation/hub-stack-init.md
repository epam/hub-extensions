# Command: hub stack init

Initialize a new stack configuration in the user working directory

## Command Parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-f --file <hubfile>` | path (or URL) to hubfile with stack definitions. This argument can repeat multile times | x |
| `-s --state <statefile>` | Path or URL to  |
| `--force` | Specify this fag if current stack has been already initialized. This flag will overwrite existing configuration  |

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |

## Usage Example

Example on how to initialize a new stack to deploy a GKE cluster

```bash
mkdir "my-gke-cluster"
cd "my-gke-cluster"
hub stack init -f "https://raw.githubusercontent.com/agilestacks/google-stacks/main/hub-just-gke.yaml"
```

## See also

* [`hub stack configure`](hub-stack-configure.md)
* [`hub stack depoy`](hub-stack-deploy.md)
* [`hub stack unconfiugre`](hub-stack-unconfiugre.md)
