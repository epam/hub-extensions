# aws
Prepares AWS prerequisites for CLI

## configure
Creates route53 and s3-bucket if missing in user AWS account by following scenario:

1. Read value for `HUB_DOMAIN_NAME`
2. Send callback to `bubble-dns/new` if needed
3. Create route53 hosted zone if missing (value `HUB_DOMAIN_NAME`)
4. Create s3 bucket (acl private) if missing (value: `<aws-account-id>.$HUB_DOMAIN_PARENT`)
5. Send callback to `bubble-dns/update`
6. Store facts in `.env`
