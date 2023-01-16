# Command: `hubctl stack ls`

Useful command when you have deployment multiple stacs from the one workdir it will help you to navigate across them

It prints stack domain name as an identifier and marks which has been set as a active with the `*` simbol

> Note. If stack doesn't have a domain name configured, then it will be displeyed as `initialized` stack

Most likely the stack has been initialized with `hubctl stack init` command however not yet configured (`hubctl stack configure`)

## See also

* [`hubctl stack init`](hub-stack-init.md)
* [`hubctl stack configure`](hub-stack-configure.md)
* [`hubctl stack set`](hub-stack-set.md)
* [`hubctl stack rm`](hub-stack-unconfigure.md)
