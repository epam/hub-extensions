# Command: hub stack ls

Useful command when you have deployment multiple stacs from the one workdir it will help you to navigate across them

It prints stack domain name as an identifier and marks which has been set as a active with the `*` simbol

> Note. If stack doesn't have a domain name configured, then it will be displeyed as `unconfigured` stack

Most likely the stack has been initialized with `hub stack init` command however not yet configured (`hub stack configure`)

## See also

* [`hub stack init`](hub-stack-init.md)
* [`hub stack configure`](hub-stack-configure.md)
* [`hub stack set`](hub-stack-set.md)
* [`hub stack unconfigure`](hub-stack-unconfigure.md)
