# Hub Components

Component is the minimal unit of the deployment for hub. Stack consists of one or multiple components. Each component knows how to deploy itself and export facts about deployment configuration in the well-known form of parameters. So other component would use this as an input.

Hub component contains the following:

1. `hub-component.yaml` - file with input and output parameters
2. `deploy` and `undeploy` provisioning scrtipts. This however optional if component is using well known deployment tool such as `terraform`, `helm` or `kustomize`.

In the nutshell - parameters defined in `hub-component.yaml` abstracts user from concrete provisioniong technology and allows maintainer of the component improve or even change provisioning technology without breaking compatibility with the other components.

## Write your own component

### Deploy a minimalistic component

1. Create a new directory `components/mynewcomponent`
2. Create a file `components/mynewcomponent/hub-component.yaml` and add minimalistic content

```yaml
kind: component
parameters:
- name: hub.componentName
  env: COMPONENT_NAME
```

3. Create a `deploy.sh` file and add execution rights to it. Here is an example

```bash
cat << EOF > `components/mynewcomponent/deploy.sh`
#!/bin/bash
echo "Component $COMPONENT_NAME deployed successfully!"
EOF
chmod +x `components/mynewcomponent/deploy.sh`
```

3. Create deployment reverse script: `undeploy.sh`

```bash
cat << EOF > `components/mynewcomponent/undeploy.sh`
#!/bin/bash
echo "Component: $COMPONENT_NAME has been successfully undeployed"
EOF
chmod +x `components/mynewcomponent/undeploy.sh`
```

4. Add a component reference to Hubfile (`hub.yaml`)

```yaml
kind: stack
meta:
  name: My first deployment
components:
- name: my-first-component
  source:
    dir: components/mynewcomponent
lifecycle:
  verbs:
  - deploy
  - undeploy
  order:
  - my-first-component
```

5. And we are ready to deploy

```bash
hub stack init -f `hub.yaml`
hub stack deploy
```

### Add a parameter

1. Add new parameter to the `components/mynewcomponent/hub-component.yaml`

```yaml
kind: component
parameters:
- name: hub.componentName
  env: COMPONENT_NAME
- name: message
  value: foo
  env: MESSAGE
```

2. Modify `components/mynewcomponent/deploy` script. You should get something like

```bash
#!/bin/bash
echo "Component $COMPONENT_NAME is saying: $MESSAGE"
echo "Component $COMPONENT_NAME deployed successfully!"
```

3. Add parameters to the hubfile (`hub.yaml`) to include parameter

```yaml
kind: stack
meta:
  name: My first deployment
components:
- name: my-first-component
  source:
    dir: components/mynewcomponent
lifecycle:
  verbs:
  - deploy
  - undeploy
  order:
  - my-first-component
parameters:
- name: message
  value: bar
```

4. Run a deployment

```bash
hub stack deploy
#
# Component my-first-component is saying: bar
# Component my-first-component deployed successfully!
```

### Add a second component and override the parameter

Modify a hubfile so it would look as the following:

```yaml
kind: stack
meta:
  name: My first deployment
components:
- name: my-first-component
  source:
    dir: components/mynewcomponent
- name: my-second-component
  source:
    dir: components/mynewcomponent
lifecycle:
  verbs:
  - deploy
  - undeploy
  order:
  - my-first-component
  - my-second-component
parameters:
- name: message
  value: bar
- name: message
  component: my-second-component
  value: baz
```

2. Run deployment

```bash
hub stack deploy
# Component my-first-component is saying: bar
# Component my-first-component deployed successfully!
# Component my-second-component is saying: baz
# Component my-second-component deployed successfully!
```

### Add a template to the component

1. Add a file that would look like the following

```bash
cat << EOF > `components/mynewcomponent/message.txt.template`
The cryptic message says: ${message}
EOF
```

2. Update `components/mynewcomponent/hub-component.yaml` so it would look like:

```yaml
kind: component
parameters:
- name: hub.componentName
  env: COMPONENT_NAME
- name: message
  value: foo
  env: MESSAGE
templates:
  files:
  - "*.template"
```

3. Modify `components/mynewcomponent/deploy.sh` so it would look like the following
```bash
#!/bin/bash
echo "Component $COMPONENT_NAME is saying: $MESSAGE"
# here we interact with template file... it has been already rendered
cat "message.txt"

echo "Component $COMPONENT_NAME deployed successfully!"
```

4. Deploy the stack

```
hub stack deploy
# Component my-first-component is saying: bar
# The cryptic message says: bar
# Component my-first-component deployed successfully!
# Component my-second-component is saying: baz
# The cryptic message says: baz
# Component my-second-component deployed successfully!
```

## Technology specific components

This article is not a reference guide, we do skip many things... Now we will jump into the more advanced topics. Until then we were writing a sudo component using a free form. Now we will use arguably oppinionated deployment steps however, you don't required to write your own deployment script

At present we support following technologies

* [Component Helm](hub-component-helm.md)
* [Component Kustomize](hub-component-kustomize.md)
* [Component Terraform](hub-component-terraform.md)
