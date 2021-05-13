#!/usr/bin/env sh

export CPU=$(grep -c ^processor /proc/cpuinfo);
export TOTALMEM=$(free -m | awk '/^Mem:/{print $2}');

if [[ "$CPU" -le "2" ]]; then TOTALCPU=2; else TOTALCPU="${CPU}"; fi

# PHP-FPM settings
if [[ -z $PHP_START_SERVERS ]]; then PHP_START_SERVERS=$(($TOTALCPU / 2)) ; fi
if [[ -z $PHP_MIN_SPARE_SERVERS ]]; then PHP_MIN_SPARE_SERVERS=$(($TOTALCPU / 2)); fi
if [[ -z $PHP_MAX_SPARE_SERVERS ]]; then PHP_MAX_SPARE_SERVERS="${TOTALCPU}"; fi
if [[ -z $PHP_MEMORY_LIMIT ]]; then PHP_MEMORY_LIMIT=$(($TOTALMEM / 2)); fi
if [[ -z $PHP_MAX_CHILDREN ]]; then PHP_MAX_CHILDREN=$(($TOTALCPU * 2)); fi

echo "CPU: ${CPU}";
echo "TOTALCPU: ${TOTALCPU}";
echo "TOTALMEM: ${TOTALMEM}";
echo "PHP_START_SERVERS: ${PHP_START_SERVERS}";
echo "PHP_MIN_SPARE_SERVERS: ${PHP_MIN_SPARE_SERVERS}"
echo "PHP_MAX_SPARE_SERVERS: ${PHP_MAX_SPARE_SERVERS}"
echo "PHP_MEMORY_LIMIT: ${PHP_MEMORY_LIMIT}"
echo "PHP_MAX_CHILDREN: ${PHP_MAX_CHILDREN}"

esh -o $PHP_CONF_PREFIX/php-fpm.conf /template/php-fpm.conf
esh -o $PHP_CONF_PREFIX/php-fpm.d/frontend.conf /template/php-fpm-frontend.conf
esh -o $PHP_CONF_PREFIX/php-fpm.d/backend.conf /template/php-fpm-backend.conf
esh -o $PHP_CONF_PREFIX/conf.d/zz-php.ini /template/zz-php.ini


composer global config sort-packages true
composer global config preferred-install dist
composer global config optimize-autoloader true
composer global config classmap-authoritative true
composer global config apcu-autoloader true
composer global require hirak/prestissimo