# Command: `hubctl state`

Helps you to manage stacks states

## Available Commands

Extensions provides following commands:

| Command   | Description |
| --------- | ---------   |
| [`hubctl state ls`](hub-state-ls.md) | List all stacks states within a project |
| [`hubctl state rm`](hub-state-rm.md) | Removes stack state from the project by Stack ID |
| [`hubctl state show`](hub-state-show.md) | Show details of a stack states by Stack ID |

## Flags

These parameters applies across all extension commands

| Flag      | Description | Required |
| :-------- | :--------   | :-:      |
| `-h, --help` | Print help and usage message | |
| `-o, --output string` | Output format. Must be one of [table, json] | |
| `-p, --project string` | GCP Project ID | |
| `-l, --stateAPILocation string` | Location of State API endpoint (default "us-central1") | |
| `-v, --verbose` | Verbose output for diagnostics | |

## Usage examples

List all stacks states

```bash
hubctl state ls
```

Show details of a stack

```bash
hubctl state show "<stack ID>"
```

Remove stack state

```bash
hubctl state rm "<stack ID>"
```
