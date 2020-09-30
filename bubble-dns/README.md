# bubble-dns

This is a technical extension to hold bubble-dns extensions. At present it has one minor `roure53` calls, however in the future we should be able to remove such dependency

Alternative URL for bubble DNS can be configured by setting user value for `HUB_BUBBLE_DNS_URL`

## new 
Connects to the bubble DNS and asks for new DNS name. Results will be written to the `.env` file

## update
Reads `.env` file and sends update to bubble-dns to insert or extend TTL for this DNS
