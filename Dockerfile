FROM alpine:edge

ARG PHP_FPM_UPSTREAM='localhost:9000'
ARG NGINX_PROXY_UPSTREAM='localhost:8080'
ARG REDIS_UPSTREAM='127.0.0.1:6379'
ARG REDIS_SKIP_FETCH_REQUEST_METHOD='POST PUT'
ARG GEO_RATELIMIT_IP='10.0.0.0/8 192.168.0.0/24 127.0.0.0/24'
ARG GEO_PURGE_ALLOWED_IP='127.0.0.1 192.168.0.0/24'
ARG GEO_WHITELIST_ACCESS_IP='127.0.0.1'
ARG ROBOT_NOINDEX=false
ARG NGINX_SERVER_NAME=my-test-site
ARG DOMAIN_ZONE=dev

ENV VAR_PREFIX=/var/run \
    LOG_PREFIX=/var/log/nginx \
    TEMP_PREFIX=/tmp \
    CACHE_PREFIX=/var/cache \
    CONF_PREFIX=/etc/nginx \
    CERTS_PREFIX=/etc/ssl-certs \
    NGINX_SERVER_NAME=${NGINX_SERVER_NAME:-localhost} \
    DOMAIN_ZONE=${DOMAIN_ZONE:-dev} \
    NGINX_CONFIG=html \
    NGINX_DOCROOT=/var/www \
    PHP_FPM_UPSTREAM=${PHP_FPM_UPSTREAM:-false} \
    NGINX_PROXY_UPSTREAM=${NGINX_PROXY_UPSTREAM:-false} \
    REDIS_UPSTREAM=${REDIS_UPSTREAM:-false} \
    REDIS_SKIP_FETCH_REQUEST_METHOD=${REDIS_SKIP_FETCH_REQUEST_METHOD} \
    MKCERT_VERSION=1.4.3 \
    GEO_IP_DB_DIR=/usr/local/share/GeoIP/ \
    GEO_RATELIMIT_IP=${GEO_RATELIMIT_IP:-false} \
    GEO_PURGE_ALLOWED_IP=${GEO_PURGE_ALLOWED_IP:-false} \
    GEO_WHITELIST_ACCESS_IP=${GEO_WHITELIST_ACCESS_IP:-false} \
    ROBOT_NOINDEX=${ROBOT_NOINDEX}

COPY /geoip/ $GEO_IP_DB_DIR
COPY /conf/ /conf
COPY docker-entrypoint.sh /usr/local/sbin/docker-entrypoint
COPY check_folder.sh /usr/local/sbin/check_folder
COPY check_host.sh /usr/local/sbin/check_host
COPY check_wwwdata.sh /usr/local/sbin/check_wwwdata
COPY --from=vsokolyk/mozjpeg /release/mozjpeg*.apk /mozjpeg/
ADD https://github.com/FiloSottile/mkcert/releases/download/v${MKCERT_VERSION}/mkcert-v${MKCERT_VERSION}-linux-amd64 /usr/local/sbin/mkcert

RUN mkdir -p /run/nginx $CERTS_PREFIX $NGINX_DOCROOT \
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -h /var/cache/nginx -s /sbin/nologin -G www-data www-data \
  && echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && chown -R www-data:www-data $GEO_IP_DB_DIR \
  && apk add --no-cache --update --allow-untrusted /mozjpeg/*.apk \
  && apk add --no-cache \
   esh \
   curl \
   tini \
   nginx \
   nginx-debug \
   nginx-mod-devel-kit \
   nginx-mod-http-brotli \
   nginx-mod-http-cache-purge \
   nginx-mod-http-cookie-flag \
   nginx-mod-http-echo \
   nginx-mod-http-encrypted-session \
   nginx-mod-http-geoip \
   nginx-mod-http-naxsi \
   nginx-mod-http-xslt-filter \
   nginx-mod-http-redis2 \
   nginx-mod-http-set-misc \
  && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
   nginx-ultimate-bad-bot-blocker \
  && chmod -R +x /usr/local/sbin/ \
  && mkcert -install \
  && mkdir -p $CERTS_PREFIX \
  && mkcert \
    -key-file $CERTS_PREFIX/$NGINX_SERVER_NAME.dev-key.pem \
    -cert-file $CERTS_PREFIX/$NGINX_SERVER_NAME.dev.pem \
     $NGINX_SERVER_NAME.$DOMAIN_ZONE \
     "*.$NGINX_SERVER_NAME.$DOMAIN_ZONE" \
     mail@$NGINX_SERVER_NAME.$DOMAIN_ZONE \
     127.0.0.1 \
     ::1
#  && install-ngxblocker -x

EXPOSE 80/tcp 443/tcp

#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]