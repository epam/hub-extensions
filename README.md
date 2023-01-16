# Hub CLI extensions

Extensions are scripts written to extend [Hub CLI] functionality.

## Description

Extensions usually resides in `~/.hub/` directory and they are installed there with `hubctl extensions install` command. Extensions follow simple calling convention where Hub CLI searches for `<extension-name>` by looking for `hub-<extension-name>` executable in `./.hub/`, `$HUB_EXTENSIONS` (could be a relative path), `~/.hub/`, `/usr/(local/)share/hub`, and finally in `$PATH`. Exit code of Hub CLI is that of the extension; stdin, stdout, stderr are passed through.

There are some extensions well-known to Hub CLI:

- toolbox
- pull
- ls
- show
- configure
- stack

Well-known extensions can be called directly via `hubctl <extension name>`. Extensions whose names are not compiled into Hub CLI binary can be called via `hubctl ext <extension-name>`.

Extensions search algorithm is greedy. When `hubctl <extension name> <probably sub-command> <arg1> <-flag> <arg2>` is called, then Hub CLI searches for, in order:

- `hub-<extension name>-<probably sub-command>-<arg1>` `[-flag <arg2>]`
- `hub-<extension name>-<probably sub-command>` `[<arg1> <-flag> <arg2>]`
- `hub-<extension name>` `[<probably sub-command> <arg1> <-flag> <arg2>]`

CLI flags and arguments are not parsed by Hub CLI - they are passed as is to the extension. To set Hub CLI logging level to _debug_ use:

```shell
HUB_DEBUG=1 hubctl ext ...
```

Not all extensions supports all Hub CLI global flags, like `--debug`, `trace`, or `--force`. It's recommended to still parse those flags and ignore if not implemented.

## Requirements

Hub CLI Extensions require [jq], [yq v4]. Optionally install [AWS CLI], [kubectl], [eksctl] and [Node.js], [NPM] for `hubctl pull` extension.

[Hub CLI]: https://github.com/agilestacks/hub
[AWS CLI]: https://aws.amazon.com/cli/
[kubectl]: https://kubernetes.io/docs/reference/kubectl/overview/
[eksctl]: https://eksctl.io
[jq]: https://stedolan.github.io/jq/
[yq v4]: https://github.com/mikefarah/yq
[Node.js]: https://nodejs.org
