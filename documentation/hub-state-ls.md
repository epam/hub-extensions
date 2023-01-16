# Command: `hubctl state ls`

List all stacks states within a project

## Flags

| Flag      | Description | Required |
| :-------- | :--------   | :-:      |
| `--filter strings` | Filter by name, status or initiator. Example: --filter "name=GKE,status=incomplete" | |

## Global Flags

These parameters applies across all extension commands

| Flag      | Description | Required |
| :-------- | :--------   | :-:      |
| `-h, --help` | Print help and usage message | |
| `-o, --output string` | Output format. Must be one of [table, json] | |
| `-p, --project string` | GCP Project ID | |
| `-l, --stateAPILocation string` | Location of State API endpoint (default "us-central1") | |
| `-v, --verbose` | Verbose output for diagnostics | |

## Usage examples

```bash
hubctl state ls
hubctl state ls --filter="latestOperation.timestamp[after]=2022-05-19,status=incomplete,initiator=akranga"
hubctl state ls --filter="latestOperation.timestamp[before]=2022-05-19"
```

## See also

* [`hubctl state show`](hub-state-show.md)
* [`hubctl stack rm`](hub-state-rm.md)
