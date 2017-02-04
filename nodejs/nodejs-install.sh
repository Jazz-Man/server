#!/usr/bin/env bash

build_nodejs() {
	NODEJS_VER=v7.5.0
	NODE_ARCH=x64
	if [ $HOSTTYPE == 'x86_64' ]
	then
		NODE_ARCH=x64
	elif [ $HOSTTYPE == 'i686' ]
	then
		NODE_ARCH=x86
	fi
	NODEJS_URL="https://nodejs.org/dist/${NODEJS_VER}/node-${NODEJS_VER}-linux-${NODE_ARCH}.tar.xz"
	NODEJS_SRC_DIR="node-${NODEJS_VER}-linux-${NODE_ARCH}"
	NODEJS_BUILD_DIR=${INSTALLDIR}/nodejs
	cd ${WORK_DIR}
	wget -O- ${NODEJS_URL} | tar -xJ
	mkdir -p ${NODEJS_BUILD_DIR}
	cp --recursive --update ${NODEJS_SRC_DIR}/* ${NODEJS_BUILD_DIR}
	echo 'export PATH="'${NODEJS_BUILD_DIR}'/bin:$PATH"' >> ${HOME}/.bashrc
	cd ${NODEJS_BUILD_DIR}/bin
	./npm config set globalconfig ${NODEJS_BUILD_DIR}/npmrc
	./npm config set lobalignorefile ${NODEJS_BUILD_DIR}/npmignore
	./npm config set prefix ${NODEJS_BUILD_DIR}
	./npm config set tmp ${TMP_DIR}/npm
	./npm config set userconfig ${NODEJS_BUILD_DIR}/npmrc-userconfig

	./npm config list >> ${NODEJS_BUILD_DIR}/npmrc
	./npm config list >> ${NODEJS_BUILD_DIR}/npmrc-userconfig

}