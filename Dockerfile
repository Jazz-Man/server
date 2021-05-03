FROM alpine:edge

ENV VAR_PREFIX=/var/run \
    LOG_PREFIX=/var/log/nginx \
    TEMP_PREFIX=/tmp \
    CACHE_PREFIX=/var/cache \
    CONF_PREFIX=/etc/nginx \
    CERTS_PREFIX=/etc/pki/tls \
    NGINX_SERVER_NAME=my-test-site

COPY /geoip/ /usr/local/share/GeoIP/
COPY /conf/ /conf
COPY --from=vsokolyk/mozjpeg /release/mozjpeg*.apk /mozjpeg/
ADD https://raw.githubusercontent.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker/master/install-ngxblocker /usr/local/sbin/install-ngxblocker
ADD https://raw.githubusercontent.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker/master/setup-ngxblocker /usr/local/sbin/setup-ngxblocker
ADD https://raw.githubusercontent.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker/master/update-ngxblocker /usr/local/sbin/update-ngxblocker
ADD https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 /usr/local/sbin/mkcert

RUN mkdir -p /run/nginx \
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -h /var/cache/nginx -s /sbin/nologin -G www-data www-data \
  && echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && chown -R www-data:www-data /usr/local/share/GeoIP/ \
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
  && chmod -R +x /usr/local/sbin/ \
  && mkcert -install \
  && mkdir /cert \
  && mkcert \
    -key-file /cert/$NGINX_SERVER_NAME.dev-key.pem \
    -cert-file /cert/$NGINX_SERVER_NAME.dev.pem \
     $NGINX_SERVER_NAME.dev \
     "*.$NGINX_SERVER_NAME.dev" \
     mail@$NGINX_SERVER_NAME.dev \
     127.0.0.1 \
     ::1
#  && install-ngxblocker -x

EXPOSE 80/tcp 443/tcp

#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]