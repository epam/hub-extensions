# aws-metering

Here we have an extension dedicated to AWS marketplace metering. As we want to capture usage through this feature.

This extension will also enable user to access some previous content, something that won't be available without registered usage.

## before-deploy

At present there is only one hook, that will be triggered before user will deploy a stack or component(s) of a stack.

This script will rely to `aws-metering.productCode` extension parameters defined in the hub file
