# Command: `hubctl stack set`

Set stack by it's name as a current.

Example

```bash
hubctl stack ls
# ACTIVE  STACK
# *       abc.example.com
#         cde.example.com

hubctl stack set "cde.example.com"

hubctl stack ls
# ACTIVE  STACK
#         abc.example.com
# *       cde.example.com
```

## See also

* [`hubctl stack init`](hub-stack-init.md)
* [`hubctl stack configure`](hub-stack-configure.md)
* [`hubctl stack ls`](hub-stack-ls.md)
* [`hubctl stack unconfigure`](hub-stack-unconfigure.md)
