## Hub CLI extensions

Extensions are scripts written to extend Hub CLI functionality.

Extensions usually resides in `~/.hub/` directory and they are installed there with `hub extensions install` command. Extensions follow simple calling convention where Hub CLI searches for `<extension-name>` by looking for `hub-<extension-name>` executable in `$PATH`, `./.hub/`, and then `~/.hub/`. Exit code of Hub CLI is that of the extension; stdin, stdout, stderr are passed through.

There are some extensions well-known to Hub CLI:

- pull
- ls
- show
- configure
- toolbox

Well-known extensions can be called directly via `hub <extension name>`. Extensions whose names are not compiled into Hub CLI binary can be called via `hub ext <extension-name>`.

CLI flags and arguments are not parsed by Hub CLI - they are passed as is to the extension. To set Hub CLI logging level to _debug_ use

    HUB_DEBUG=1 hub ext ...

### hub pull

For `pull` extension you need Node.js and NPM installed.
