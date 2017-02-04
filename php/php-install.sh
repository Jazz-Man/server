#!/usr/bin/env bash

build_php()
{
	PHP_VER=7.1.1
	PHP_ENV=development #or production
	PHP_SRC="https://php.net/distributions/php-${PHP_VER}.tar.xz"
	PHP_SRC_DIR=php-src
	cd ${WORK_DIR} && mkdir -p php && cd php
	
	echo "Скачую PHP=${PHP_VER} із '${PHP_SRC}'"
	curl -fsSL ${PHP_SRC} | tar -xJf - --strip-components=1
	PHP_PREFIX=${INSTALLDIR}/php
	PHP_LIB_DIR=${PHP_PREFIX}/lib
	CON_FILE_PATCH=${PHP_PREFIX}/etc
	CON_FILE_SCAN_PATCH=${CON_FILE_PATCH}/conf.d
	
	PHP_INI="$CON_FILE_PATCH/php.ini"
	
	PHP_INSTALL_DIR="\
	--prefix=$PHP_PREFIX"
	
	PHP_EXT_ENABLE="\
	--enable-fpm \
	--enable-bcmath\
	--enable-calendar \
	--enable-exif \
	--enable-ftp \
	--enable-gd-native-ttf \
	--enable-intl \
	--enable-mbstring=all \
	--enable-embedded-mysqli \
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
  --with-pear=${PHP_LIB_DIR}/php\
  --with-config-file-path=${CON_FILE_PATCH} \
  --with-config-file-scan-dir=${CON_FILE_PATCH}/conf.d"
	
	
	echo "Скачування закінчено"\n
	echo "Конфігурую PHP=${PHP_VER}"
	
	./configure \
	 ${PHP_EXT_ENABLE} \
	 ${PHP_EXT_DISABLE} \
	 ${PHP_EXT_WITH} \
	 --config-cache \
	 --enable-embed=shared \
	 ${PHP_INSTALL_DIR}
	
	make -j`nproc`
	echo "Встановлюю PHP=${PHP_VER} в папку '${PHP_PREFIX}'"
	make install
	echo "Копіюю 'php.ini' в папку '${PHP_INI}'"
	install -D -m644 php.ini-${PHP_ENV} ${PHP_INI}
	echo "Додаю  'PHP=${PHP_VER}' в '\$PATH'"
	echo 'export PATH="'${PHP_PREFIX}'/bin:$PATH"' >> ${HOME}/.bashrc
	
	echo "Перевіряю встановлену версію 'php -v'"
	reload_bashrc
	php -v
	echo "Все добре:)"
	
	echo "Конфігурую 'pear'"
	echo "Створюю структуру папок для 'pear'"
	PEAR_DOWNLOAD_DIR=${TMP_DIR}/pear/download
	PEAR_TEMP_DIR=${TMP_DIR}/pear/temp
	PEAR_CASHE_DIR=${TMP_DIR}/pear/cache
	PEAR_METADATA_DIR=${TMP_DIR}/pear/metadata
	
	mkdir -p ${PEAR_DOWNLOAD_DIR}
	mkdir -p ${PEAR_TEMP_DIR}
	mkdir -p ${PEAR_CASHE_DIR}
	mkdir -p ${PEAR_METADATA_DIR}
	
	echo "PEAR Installer cache directory 'cache_dir'='${PEAR_CASHE_DIR}'"
	pear config-set cache_dir ${PEAR_CASHE_DIR}
	
	echo "PEAR Installer download 'download_dir'='${PEAR_DOWNLOAD_DIR}'"
	pear config-set download_dir ${PEAR_DOWNLOAD_DIR}
	
	echo "PEAR Installer temp directory 'temp_dir'='${PEAR_TEMP_DIR}'"
	pear config-set temp_dir ${PEAR_TEMP_DIR}
	
	echo "PEAR metadata directory 'metadata_dir'='${PEAR_METADATA_DIR}'"
	pear config-set metadata_dir ${PEAR_METADATA_DIR}
	
	echo "php.ini location 'php_ini'='${PHP_INI}'"
	pear config-set php_ini ${PHP_INI}
	
	pear config-show
	
	install_xdebug
#	install_phalcon

}