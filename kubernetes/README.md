# kubernetes

Provides configuration to use with kuberenetes requirement. We cannot expect that CLI user will follow hubctl naming conventions. Historically it has been designed for automation tasks.

Yet, we cannot guarantee that some of the components will want to modify a kubeconfig file (`kubeflow` component is notorious for doing that). In this case user should not be affected. So, at present if any stack component will try to modify file, it will be limited to kubeconfig created by `./configure` script

## configure

This is the only script so far. It will do the following
1. Take kubeconfig (as parameter or `KUBECONFIG` env var)
2. Extract `user`, `cluster`, and `auth` info from the file (only necessary for the deployment of one concrete stack)
3. Store it as `.hub/env/$HUB_DOMAIN_NAME.kubeconfig` file
4. Change current context in this file.
5. Add `KUBECONFIG` declaration to the .env file

For compatibility with hubctl components it will rely that context name is the same as `HUB_DOMAIN_NAME`
