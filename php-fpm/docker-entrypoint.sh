#!/usr/bin/env sh

CPU=$(grep -c ^processor /proc/cpuinfo);
TOTALMEM=$(free -m | awk '/^Mem:/{print $2}');

if [[ "$CPU" -le "2" ]]; then TOTALCPU=2; else TOTALCPU="${CPU}"; fi

# PHP-FPM settings
if [[ -z $PHP_START_SERVERS ]]; then PHP_START_SERVERS=$(($TOTALCPU / 2)) ; fi
if [[ -z $PHP_MIN_SPARE_SERVERS ]]; then PHP_MIN_SPARE_SERVERS=$(($TOTALCPU / 2)); fi
if [[ -z $PHP_MAX_SPARE_SERVERS ]]; then PHP_MAX_SPARE_SERVERS="${TOTALCPU}"; fi
if [[ -z $PHP_MEMORY_LIMIT ]]; then PHP_MEMORY_LIMIT=$(($TOTALMEM / 2)); fi
if [[ -z $PHP_MAX_CHILDREN ]]; then PHP_MAX_CHILDREN=$(($TOTALCPU * 2)); fi

esh -o $PHP_CONF_PREFIX/php-fpm.conf /template-php-fpm/php-fpm.conf
esh -o $PHP_CONF_PREFIX/php-fpm.d/frontend.conf /template-php-fpm/php-fpm-frontend.conf

if [ "$PHP_FPM_ENABLE_BACKEND_POOL" != "false" ]; then
  esh -o $PHP_CONF_PREFIX/php-fpm.d/backend.conf /template-php-fpm/php-fpm-backend.conf
fi

esh -o $PHP_CONF_PREFIX/conf.d/zz-php.ini /template-php-fpm/zz-php.ini

chown -R $WWW_USER:$WWW_USER_GROUP $PHP_CONF_PREFIX