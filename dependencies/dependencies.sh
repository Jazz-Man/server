#!/usr/bin/env bash

install_cmake() {
	cd ${WORK_DIR}
	echo "Installing CMake"
	CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz"
	CMAKE_LIB_DIR=${WORK_DIR}/cmake-3.7.2
	CMAKE_BUILD_DIR=${COMMON_DIR}/cmake
	wget -O- ${CMAKE_URL} | tar xvz
	cd ${CMAKE_LIB_DIR}
	./bootstrap \
	--prefix=${CMAKE_BUILD_DIR}
	make -j`nproc` && make install
	echo 'export PATH="'${CMAKE_BUILD_DIR}'/bin:$PATH"' >> ${HOME}/.bashrc
	reload_bashrc
	cd ${WORK_DIR}
	rm -rf ${CMAKE_LIB_DIR}
}

install_pcre() {
	cd ${WORK_DIR}
	echo "Installing Stac Dependencies"
	echo "the PCRE library"
	PCRE_LIB_URL="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz"
	PCRE_LIB_DIR=${WORK_DIR}/pcre-8.40
	PCRE_BUILD_DIR=${COMMON_DIR}/pcre
	wget -O- ${PCRE_LIB_URL} | tar xvz
	cd ${PCRE_LIB_DIR}
	./configure \
	 --prefix=${PCRE_BUILD_DIR}
	make -j`nproc` && make install
	echo 'export PATH="'${PCRE_BUILD_DIR}'/bin:$PATH"' >> ${HOME}/.bashrc
	reload_bashrc
	cd ${WORK_DIR}
	rm -rf ${PCRE_LIB_DIR}
}

install_zlib() {
	cd ${WORK_DIR}
	echo "the zlib library"
	ZLIB_LIB_URL="http://zlib.net/zlib-1.2.11.tar.gz"
	ZLIB_LIB_DIR=${WORK_DIR}/zlib-1.2.11
	ZLIB_BUILD_DIR=${COMMON_DIR}/zlib
	wget -O- ${ZLIB_LIB_URL} | tar xvz
	cd ${ZLIB_LIB_DIR}
	./configure \
	 --prefix=${ZLIB_BUILD_DIR}
	make -j`nproc` && make install
	rm -rf ${ZLIB_LIB_DIR}
}

install_openssl() {
	cd ${WORK_DIR}
	echo "the OpenSSL library"
	OPEN_SSL_LIB_URL="http://www.openssl.org/source/openssl-1.0.2f.tar.gz"
	OPEN_SSL_LIB_DIR=${WORK_DIR}/openssl-1.0.2f
	OPEN_SLL_BUID_DIR=${COMMON_DIR}/openssl
	wget -O- ${OPEN_SSL_LIB_URL} | tar xvz
	cd ${OPEN_SSL_LIB_DIR}
	./config \
	 --prefix=${OPEN_SLL_BUID_DIR}
	make -j`nproc` && make install
	echo 'export PATH="'${OPEN_SLL_BUID_DIR}'/bin:$PATH"' >> ${HOME}/.bashrc
	reload_bashrc
	rm -rf ${OPEN_SSL_LIB_DIR}
}

build_dependencies() {
	install_cmake
#	install_pcre
#	install_zlib
#	install_openssl
}
