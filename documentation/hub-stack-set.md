# Command: hub stack set

Set stack by it's name as a current.

Example

```bash
hub stack ls
# ACTIVE  STACK
# *       abc.example.com
#         cde.example.com

hub stack set "cde.example.com"

hub stack ls
# ACTIVE  STACK
#         abc.example.com
# *       cde.example.com
```

## See also

* [`hub stack init`](hub-stack-init.md)
* [`hub stack configure`](hub-stack-configure.md)
* [`hub stack ls`](hub-stack-ls.md)
* [`hub stack unconfigure`](hub-stack-unconfigure.md)
