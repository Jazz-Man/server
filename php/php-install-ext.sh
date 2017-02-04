#!/usr/bin/env bash

install_xdebug()
{
	echo "Installation XDEBUG EXTENSION FOR PHP"
	pecl install xdebug
	reload_bashrc

}

install_phalcon()
{
	
	cd ${WORK_DIR}
	phalcon=cphalcon/build
	
	phalcon_url="git://github.com/phalcon/cphalcon.git"

	git clone ${phalcon_url}
	
	cd ${phalcon}
	
	export CC="gcc"
	export CFLAGS="-march=native -mtune=native -O2 -fomit-frame-pointer"
	export CPPFLAGS="-DPHALCON_RELEASE"
	PHP_FULL_VERSION=`php-config --version`
	if [ $? != 0 ]; then
		echo "php-config is not installed"
		exit 1
	fi
	
	if [ "${PHP_FULL_VERSION:0:3}" == "5.3" ]; then
		echo "php 5.3 is no longer supported"
		exit 1
	fi
	
	if [ "${PHP_FULL_VERSION:0:3}" == "5.4" ]; then
		echo "php 5.4 is no longer supported"
		exit 1
	fi
	
	if [ "${PHP_FULL_VERSION:0:1}" == "5" ]; then
		PHP_VERSION="php5"
	else
		PHP_VERSION="php7"
	fi
	
	echo "int main() {}" > t.c
	gcc ${CFLAGS} t.c -o t 2 > t.t
	if [ $? != 0 ]; then
		chmod +x gcccpuopt
		BFLAGS=`./gcccpuopt`
		export CFLAGS="-O2 -fomit-frame-pointer $BFLAGS"
		gcc ${CFLAGS} t.c -o t 2 > t.t
		if [ $? != 0 ]; then
			export CFLAGS="-O2"
		fi
	fi
	
	if [ $(gcc -dumpversion | cut -f1 -d.) -ge 4 ]; then
		gcc ${CFLAGS} -fvisibility=hidden t.c -o t 2 > t.t && export CFLAGS="$CFLAGS -fvisibility=hidden"
	fi
	
	rm -f t.t t.c t
	
	if [ -z $1 ]; then
		DIR="32bits"
		gcc gccarch.c -o gccarch
		if [ -f gccarch ]; then
			P64BITS=`./gccarch`
			if [ "$P64BITS" == "1" ]; then
				DIR="64bits"
			fi
		fi
	else
		DIR=$1
	fi
	
	cd "$PHP_VERSION/$DIR"
	
	if [ -f Makefile ]; then
		make clean
		phpize --clean
	fi
	
	phpize
	./configure --enable-phalcon
	make -j`nproc`
	make install
	echo -e "\nThanks for compiling Phalcon!\nBuild succeed: Please restart your web server to complete the installation"
	echo 'extension=phalcon.so' >> ${PHP_INI}
}