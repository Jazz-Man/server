FROM vsokolyk/php-fpm

ARG NGINX_LISTEN_PORT
ARG NGINX_ENABLE_ACCESS_LOG
ARG NGINX_SERVER_NAME
ARG NO_LOGS_USER_AGENT='Monit'
ARG ROBOT_NOINDEX=false
ARG NGINX_SERVER_ROOT=/var/www/html
ARG NGINX_DOCROOT=""

ENV VAR_PREFIX=/var/run \
    NGINX_LOG_PREFIX=/var/log/nginx \
    NGINX_ENABLE_ACCESS_LOG=${NGINX_ENABLE_ACCESS_LOG:-false} \
    NGINX_CONF_PREFIX=/etc/nginx \
    NGINX_SERVER_NAME=${NGINX_SERVER_NAME:-_} \
    NGINX_SERVER_ROOT=${NGINX_SERVER_ROOT:-/var/www/html} \
    NGINX_DOCROOT=${NGINX_DOCROOT} \
    NGINX_LISTEN_PORT=${NGINX_LISTEN_PORT:-80} \
    REDIS_UPSTREAM=${REDIS_UPSTREAM:-false} \
    NOCACHE_COOKIE='comment_author wp-postpass wordpress_test_cookie wordpress_no_cache wordpress_logged_in' \
    NO_LOGS_USER_AGENT=${NO_LOGS_USER_AGENT} \
    ROBOT_NOINDEX=${ROBOT_NOINDEX}

WORKDIR $NGINX_SERVER_ROOT

RUN mkdir -p $CACHE_PREFIX/nginx \
		$NGINX_CONF_PREFIX/after.vhost.d \
		$NGINX_CONF_PREFIX/before.vhost.d \
		$NGINX_CONF_PREFIX/sites-available \
		$NGINX_CONF_PREFIX/sites-enabled \
		/etc/supervisor/conf.d \
	&& chown $WWW_USER:$WWW_USER_GROUP $CACHE_PREFIX/nginx \
	&& apk add --no-cache \
		git@main-edge \
		openssh@main-edge \
		openssh-client@main-edge \
		py3-setuptools@main-edge \
		supervisor@main-edge \
		nginx@main-edge \
		nginx-mod-devel-kit@main-edge \
		nginx-mod-http-brotli@main-edge \
		nginx-mod-http-cache-purge@main-edge \
		nginx-mod-http-cookie-flag@main-edge \
		nginx-mod-http-echo@main-edge \
		nginx-mod-http-encrypted-session@main-edge \
		nginx-mod-http-naxsi@main-edge \
		nginx-mod-http-xslt-filter@main-edge \
		nginx-mod-http-set-misc@main-edge \
		nginx-ultimate-bad-bot-blocker@testing-edge \
	&& rm -rf $NGINX_SERVER_ROOT/* \
	&& mkdir -p $NGINX_SERVER_ROOT/$NGINX_DOCROOT

COPY ./docker-entrypoint.sh /usr/local/bin/nginx-entrypoint.sh
COPY conf/supervisord.conf /etc/supervisord.conf
COPY conf/conf.d/ $NGINX_CONF_PREFIX/conf.d/
COPY conf/header.d/ $NGINX_CONF_PREFIX/header.d/
COPY conf/map.d/ $NGINX_CONF_PREFIX/map.d/
COPY conf/fastcgi.d/ $NGINX_CONF_PREFIX/fastcgi.d/
COPY template/ /template-nginx/

RUN chmod -R +x /usr/local/bin \
	&& chown -R $WWW_USER:$WWW_USER_GROUP /var/lib/nginx \
	&& chown -R $WWW_USER:$WWW_USER_GROUP $NGINX_SERVER_ROOT \
	&& /usr/local/bin/php-fpm-entrypoint.sh \
	&& /usr/local/bin/nginx-entrypoint.sh

EXPOSE $NGINX_LISTEN_PORT

#CMD ["supervisord","-n","-c","/etc/supervisord.conf"]