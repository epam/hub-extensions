# Command: `hub show`

Helps to browse parameters for deployment

## Useful Parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-q  -jq --query` | Apply a `jq` style filter query to the command results | |
| `-o --split` | By default, input and output parameters of a stack has been merged. If you want to split them into two different group to view specifically input or output parameters, then use this flag | |
| `-m --machine` | By default parameters exported in a flat manner as a Key-Value pair. Yet you may want instead to present parameters as a `.` (dot) delimited objects. This can significantly simplify scripting when you want to wire deployment outputs with your specific automation | |
| `-c --component` | Show input and ouptut parameters of a specific component in the stack.  | |
| `--` |  For advanced case: when you want to supply some `jq` native arguments to the `hub show` command. Check out `jq --help` for allowed values | |

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |

## Usage Example

To show all parameters of a stac

```bash
hub show
```

To show domain name of a stack

```
hub show -q '.parameters.dns.domain'
```

To show password of a `mysql` component in the stack

```bash
hub show -c 'mysql' -q '.outputs.component.mysql.password'
```
