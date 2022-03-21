# Command: `hub toolbox`

This command will run a toolbox container in interactive mode and will let you to deploy stack without having to install all necessary tools besides a docker

Actually this command performs the following actions

1. Pull a docker image
2. Use current directory as a working directory inside of the image
3. Run a toolbox in interactive shell

## Command Parameters

| Flag   | Description | Default
| :-------- | :-------- | :-- |
| `-i --toolbox-image <docker-image>` | Use docker image for a docker toolbox | var: `HUB_TOOLBOX_IMAGE` or `agilestacks/toolbox:stable` |

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description |
| :-------- | :-------- |
| `-V --verbose` | extra verbosity for diagnostics |
| `-h --help` | print help and usage message |

## Usage Example

To start a toolbox container and run a deployment from inside

```bash
hub toolbox
# wait a doker pull
# see a docker shell instead
hub stack deploy
exit
```

## See also

* [`hub stack`](hub-stack.md)
* [`hub stack deploy`](hub-stack-deploy.md)
