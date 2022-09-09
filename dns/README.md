DoH usually encodes questions as parameters into the URL. For example:

```shell
# DNSPod
DOH_PROVIDER_URL_PREFIX="https://doh.pub/dns-query?dns="
# Google
DOH_PROVIDER_URL_PREFIX="https://dns.google/dns-query?dns="
# Cloudflare
DOH_PROVIDER_URL_PREFIX="https://cloudflare-dns.com/dns-query?dns="
DOMAIN_IN_QUESTION="www.google.com"
curl -s "${DOH_PROVIDER_URL_PREFIX}$( ./dns_payload.sh ${DOMAIN_IN_QUESTION}  |\
                                      base64                                  |\
                                      tr -d '=' )" | hexdump -C # temporary, let's decode the answer in the future
```

Bookmarks:

* https://developers.google.com/speed/public-dns/docs/intro
* https://developers.cloudflare.com/1.1.1.1/
