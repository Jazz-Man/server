#!/usr/bin/env bash

# Avoid root execution
if [ `id | sed -e s/uid=//g -e s/\(.*//g` -eq 0 ] && [ "$2" != "stop" ]; then
	echo "Execution by root not allowed"
	exit 1
fi

source ./install-ext.sh
INSTALLDIR=$HOME/nginxstack-1.10.2-0

WORK_DIR=$PWD/work

PKGVER=7.1.1
PKGBASE=php
PKGSRC=https://php.net/distributions/
PHP_ENV=development #or production

PREFIX=${INSTALLDIR}/php
LIB_DIR=${PREFIX}/lib
CON_FILE_PATCH=${PREFIX}/etc
CON_FILE_SCAN_PATCH=${CON_FILE_PATCH}/conf.d

PHP_INI="$CON_FILE_PATCH/php.ini"

rm -rf ${WORK_DIR}

mkdir -p ${WORK_DIR}/${PKGBASE}
cd ${WORK_DIR}/${PKGBASE}

# curl -fsSL ${PKGSRC}${PKGBASE}-${PKGVER}.tar.xz | tar -xJf - --strip-components=1


PHP_INSTALL_DIR="\
	--prefix=$PREFIX\
	--libexecdir=$PREFIX/lib/php/extensions"

PHP_EXT_ENABLE="\
	--enable-fpm \
	--enable-bcmath\
	--enable-calendar \
	--enable-exif \
	--enable-ftp \
	--enable-gd-native-ttf \
	--enable-intl \
	--enable-mbstring=all \
	--enable-embedded-mysqli\
    --enable-bcmath \
    --enable-sockets \
    --enable-pcntl \
    --enable-maintainer-zts \
    --enable-shmop \
	--enable-soap \
	--enable-sockets \
	--enable-sysvmsg \
	--enable-sysvsem \
	--enable-sysvshm\
	--enable-phpdbg\
	--enable-phpdbg-webhelper\
	--enable-phpdbg-debug\
	--enable-wddx"

PHP_EXT_DISABLE="--disable-cgi"


PHP_EXT_WITH="\
	--with-layout=GNU \
	--with-bz2 \
	--with-curl \
    --with-bz2 \
    --with-curl \
    --with-libzip \
    --with-mcrypt \
	--with-mhash \
	--with-fpm-user=daemon \
	--with-fpm-group=daemon \
    --with-libedit \
    --with-openssl \
    --with-zlib \
    --with-readline \
    --with-sqlite3 \
    --with-xmlrpc \
    --with-pear=${LIB_DIR}/php\
    --with-config-file-path=${CON_FILE_PATCH} \
    --with-config-file-scan-dir=${CON_FILE_PATCH}/conf.d"

# ./configure \
# 	${PHP_EXT_ENABLE}\
# 	${PHP_EXT_DISABLE}\
# 	${PHP_EXT_WITH}\
# 	--config-cache \
# 	--enable-embed=shared \
#     ${PHP_INSTALL_DIR}

# make -j`nproc`
# make install
# install -D -m644 php.ini-$PHP_ENV $PHP_INI

cd ..

cd ${PREFIX}/bin

PHP_FULL_VERSION=`./php-config --version`

PHP_CONFIG_PREF="\
	--with-php-config=$PREFIX/bin/php-config"

cd ${WORK_DIR}

install_xdebug
install_phalcon

echo "${PHP_FULL_VERSION}"

# rm -rf ${WORK_DIR}



cd ${PREFIX}/bin
./php -v
