# Command: `hubctl stack rm`

This command is basically deletes stack configuration created via `hubctl stack init` or `hubctl stack configure` commands.

This command won't undeploy a stack if it has been deployed

Common usage scenario is actually a clean up your working directory from stacks that has been previously undeployed and you don't have use of them anymore

## See also

* [`hubctl stack init`](hub-stack-init.md)
* [`hubctl stack configure`](hub-stack-configure.md)
* [`hubctl stack ls`](hub-stack-ls.md)
* [`hubctl stack set`](hub-stack-set.md)
