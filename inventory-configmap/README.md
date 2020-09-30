# inventory-configmap

Extension to handle storing state of the deployment as a configmap. For better compatibility with applications, when it wants to `ls` and `show` parameters of a stack to be able configure itself properly

## after-deploy

Currently only script we have so far. Triggered after `stack deploy` succeeds. It will take deployment state and storee in `kube-system/superhub` configmap.

Note:
  `HUB_DOMAIN_NAME` has been discovered from `.env` file
