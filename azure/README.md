# azure
Prepares Azure prerequisites for CLI

## configure
Creates DNX zone and storage account with blob container if missing in current subscription:

1. Read value for `HUB_DOMAIN_NAME`
2. Send callback to `bubble-dns/new` if needed
3. Create Azure DNS zone if missing (value `HUB_DOMAIN_NAME`)
4. Create storage account and private blob container if missing (value: `superhub-<subscription id>`)
5. Send callback to `bubble-dns/update`
6. Store facts in `.env`
