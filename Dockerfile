FROM alpine:3.12

ENV VAR_PREFIX=/var/run \
    LOG_PREFIX=/var/log/nginx \
    TEMP_PREFIX=/tmp \
    CACHE_PREFIX=/var/cache \
    CONF_PREFIX=/etc/nginx \
    CERTS_PREFIX=/etc/pki/tls