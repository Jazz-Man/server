FROM alpine:edge

ARG PHP_LOG_STDERR
ARG PHP_FPM_FRONTEND_PORT
ARG PHP_FPM_BACKEND_PORT
ARG PHP_FPM_ENABLE_BACKEND_POOL
ARG PHP_FPM_ENABLE_ACCESS_LOG
ARG PHP_FPM_ENABLE_SLOW_LOG
ARG PHP_FPM_SLOW_LOG_TIMEOUT
ARG PHP_START_SERVERS
ARG PHP_MIN_SPARE_SERVERS
ARG PHP_MAX_SPARE_SERVERS
ARG PHP_MEMORY_LIMIT
ARG PHP_OPCACHE_MEMORY_CONSUMPTION
ARG PHP_MAX_CHILDREN
ARG PHP_POST_MAX_SIZE
ARG PHP_UPLOAD_MAX_FILESIZE
ARG PHP_MAX_INPUT_VARS
ARG PHP_MAX_EXECUTION_TIME
ARG PHP_OPCACHE_ENABLE
ARG PHP_SESSION_SERIALIZE_HANDLER
ARG WWW_USER
ARG WWW_USER_GROUP
ARG REDIS_UPSTREAM
ARG CACHE_PREFIX=/var/cache
ARG COMPOSER_HOME=/opt/composer

ENV TERM=xterm \
	PAGER=more \
	WWW_USER=${WWW_USER:-www-data} \
	WWW_USER_GROUP=${WWW_USER_GROUP:-www-data} \
	VAR_PREFIX=/var/run \
	CACHE_PREFIX=${CACHE_PREFIX} \
	TEMP_PREFIX=/tmp \
	PHP_LOG_PREFIX=/var/log/php-fpm \
	PHP_LISTEN_PREFIX=${VAR_PREFIX}/php-fpm \
	PHP_CONF_PREFIX=/etc/php7 \
	PHP_LIB_DIR=/var/lib/php7 \
	PHP_LOG_STDERR=${PHP_LOG_STDERR:-true} \
	PHP_FPM_ENABLE_ACCESS_LOG=${PHP_FPM_ENABLE_ACCESS_LOG:-false} \
	PHP_FPM_ENABLE_SLOW_LOG=${PHP_FPM_ENABLE_SLOW_LOG:-false} \
	PHP_FPM_ENABLE_BACKEND_POOL=${PHP_FPM_ENABLE_BACKEND_POOL:-false} \
	PHP_FPM_SLOW_LOG_TIMEOUT=${PHP_FPM_SLOW_LOG_TIMEOUT:-3s} \
	PHP_FPM_FRONTEND_PORT=${PHP_FPM_FRONTEND_PORT:-false} \
	PHP_FPM_BACKEND_PORT=${PHP_FPM_BACKEND_PORT:-false} \
	PHP_START_SERVERS=${PHP_START_SERVERS} \
    PHP_MIN_SPARE_SERVERS=${PHP_MIN_SPARE_SERVERS} \
    PHP_MAX_SPARE_SERVERS=${PHP_MAX_SPARE_SERVERS} \
    PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-512} \
    PHP_OPCACHE_MEMORY_CONSUMPTION=${PHP_OPCACHE_MEMORY_CONSUMPTION} \
    PHP_MAX_CHILDREN=${PHP_MAX_CHILDREN} \
    PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-100} \
    PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE:-100} \
    PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS:-10000} \
    PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME:-300} \
    PHP_OPCACHE_ENABLE=${PHP_OPCACHE_ENABLE:-1} \
    PHP_SESSION_SERIALIZE_HANDLER=${PHP_SESSION_SERIALIZE_HANDLER:-igbinary} \
    REDIS_UPSTREAM=${REDIS_UPSTREAM:-false} \
    COMPOSER_HTACCESS_PROTECT=1 \
    COMPOSER_HOME=${COMPOSER_HOME} \
    COMPOSER_BIN_DIR=/usr/local/bin \
    COMPOSER_CACHE_DIR=${CACHE_PREFIX}/composer

COPY --from=vsokolyk/mozjpeg /release/mozjpeg*.apk /mozjpeg/

RUN mkdir -p \
		$VAR_PREFIX \
		$CACHE_PREFIX \
		$PHP_LIB_DIR/sessions \
		$PHP_LIB_DIR/opcache \
		$PHP_LOG_PREFIX \
		$PHP_LISTEN_PREFIX \
		$COMPOSER_HOME \
		$COMPOSER_CACHE_DIR

RUN set -x \
	&& addgroup -g 82 -S $WWW_USER \
    && adduser -u 82 -D -S -h /home/$WWW_USER -s /sbin/nologin -G $WWW_USER $WWW_USER_GROUP \
    && echo "@main-edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "@community-edge http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "@testing-edge http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "@community-legacy http://dl-cdn.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories \
	&& apk add --no-cache --allow-untrusted /mozjpeg/*.apk \
    && apk add --no-cache --update \
      esh@main-edge \
      php7@community-edge \
      php7-dev@community-edge \
      php7-apcu@community-edge \
      php7-bcmath@community-edge \
      php7-bz2@community-edge \
      php7-brotli@community-edge \
      php7-dom@community-edge \
      php7-calendar@community-edge \
      php7-common@community-edge \
      php7-ctype@community-edge \
      php7-cli@community-edge \
      php7-curl@community-edge \
      php7-ffi@community-edge \
      php7-fileinfo@community-edge \
      php7-fpm@community-edge \
      php7-exif@community-edge \
      php7-enchant@community-edge \
      php7-embed@community-edge \
      php7-gettext@community-edge \
      php7-gd@community-edge \
      php7-iconv@community-edge \
      php7-igbinary@community-edge \
      php7-imagick@community-edge \
      php7-json@community-edge \
      php7-ldap@community-edge \
      php7-mailparse@community-edge \
      php7-mbstring@community-edge \
      php7-mcrypt@community-edge \
      php7-mysqli@community-edge \
      php7-mysqlnd@community-edge \
      php7-opcache@community-edge \
      php7-openssl@community-edge \
      php7-odbc@community-edge \
      php7-pdo@community-edge \
      php7-pdo_mysql@community-edge \
      php7-pdo_pgsql@community-edge \
      php7-pdo_sqlite@community-edge \
      php7-phar@community-edge \
      php7-posix@community-edge \
      php7-pcntl@community-edge \
      php7-redis@community-edge \
      php7-session@community-edge \
      php7-soap@community-edge \
      php7-sockets@community-edge \
      php7-sodium@community-edge \
      php7-sqlite3@community-edge \
      php7-tokenizer@community-edge \
      php7-tidy@community-edge \
      php7-pecl-pcov@testing-edge \
      php7-pecl-maxminddb@community-edge \
      php7-pear@community-edge \
      php7-pecl-msgpack@community-edge \
      php7-xmlrpc@community-edge \
      php7-xml@community-edge \
      php7-xmlreader@community-edge \
      php7-xmlwriter@community-edge \
      php7-simplexml@community-edge \
      php7-zip@community-edge \
      php7-zlib@community-edge \
      php7-yaml@community-edge \
      mysql-client@main-edge \
      gettext@main-edge \
      composer@community-legacy

COPY ./template/* /template-php-fpm/
COPY ./docker-entrypoint.sh /usr/local/bin/php-fpm-entrypoint.sh

RUN chmod -R +x /usr/local/bin \
    && echo 'alias wp="wp --allow-root"' >> /root/.bashrc \
    && rm -rf $PHP_CONF_PREFIX/php-fpm.d/*.conf \
    && /usr/local/bin/php-fpm-entrypoint.sh \
	&& composer global config sort-packages true \
	&& composer global config preferred-install dist \
	&& composer global config optimize-autoloader true \
	&& composer global config classmap-authoritative true \
	&& composer global config apcu-autoloader true \
	&& composer global require \
			hirak/prestissimo \
#			dg/composer-cleaner \
			roave/security-advisories:dev-master \
	&& composer global require \
		wp-cli/wp-cli-bundle \
		wp-cli/admin-command \
		wp-cli/dist-archive-command \
		wp-cli/doctor-command \
		wp-cli/find-command \
		wp-cli/profile-command \
		wp-cli/scaffold-package-command \
	&& rm /usr/local/bin/composer \
	&& chown -R \
		$WWW_USER:$WWW_USER_GROUP \
		$PHP_CONF_PREFIX \
		$PHP_LOG_PREFIX \
		$CACHE_PREFIX \
		$VAR_PREFIX \
		$PHP_LIB_DIR \
		$PHP_LISTEN_PREFIX \
		$COMPOSER_HOME \
		$COMPOSER_CACHE_DIR \
		/usr/local/bin \
	&& rm -rf $PHP_LIB_DIR/opcache/* \
	&& rm -rf $TEMP_PREFIX/* \
	&& rm -rf $CACHE_PREFIX/apk/* \
	&& rm -rf $COMPOSER_CACHE_DIR/*

USER $WWW_USER