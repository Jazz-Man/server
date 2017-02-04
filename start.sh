#!/usr/bin/env bash

# Avoid root execution
if [ `id | sed -e s/uid=//g -e s/\(.*//g` -eq 0 ] && [ "$2" != "stop" ]; then
	echo "Execution by root not allowed"
	exit 1
fi

source ./util.sh
source ./dependencies/dependencies.sh
source ./php/php-install.sh
source ./php/php-install-ext.sh
source ./nginx/nginx-install.sh
source ./nodejs/nodejs-install.sh
source ./mysql/mysql-install.sh
INSTALLDIR=$HOME/stack
TMP_DIR=${INSTALLDIR}/tmp
SRC_DIR=${INSTALLDIR}/src
COMMON_DIR=${INSTALLDIR}/common

WORK_DIR=$PWD/work

rm -rf ${WORK_DIR}
mkdir -p ${WORK_DIR}
mkdir -p ${COMMON_DIR}
mkdir -p ${INSTALLDIR}
mkdir -p ${TMP_DIR}
mkdir -p ${SRC_DIR}

#build_dependencies
#build_php
#build_nginx
build_nodejs
#build_mysql

#rm -rf ${WORK_DIR}

