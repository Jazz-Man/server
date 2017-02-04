#!/usr/bin/env bash

build_nginx() {
	
	cd ${WORK_DIR}

	NGINX_VER='nginx-1.11.9'
	NGINX_SRC="http://nginx.org/download/${NGINX_VER}.tar.gz"
	NGINX_PREFIX=${INSTALLDIR}/nginx
	NGINX_TMP_DIR=${TMP_DIR}/nginx
	NGINX_CLIENT_BODY_TEMP=${NGINX_TMP_DIR}/client_body_temp
	NGINX_PROXY_TEMP=${NGINX_TMP_DIR}/proxy_temp
	NGINX_FASTCGI_TEMP=${NGINX_TMP_DIR}/fastcgi_temp
	NGINX_UWSGI_TEMP=${NGINX_TMP_DIR}/uwsgi_temp
	NGINX_SCGI_TEMP=${NGINX_TMP_DIR}/scgi_temp
	
	
	echo "Installing nginx Stac Dependencies"
	echo "the PCRE library"
	NGINX_PCRE_LIB_SRC="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz"
	wget -O- ${NGINX_PCRE_LIB_SRC} | tar xvz
	NGINX_PCRE_LIB_DIR=${WORK_DIR}/pcre-8.40
	
	echo "the zlib library"
	NGINX_ZLIB_LIB_SRC="http://zlib.net/zlib-1.2.11.tar.gz"
	wget -O- ${NGINX_ZLIB_LIB_SRC} | tar xvz
	NGINX_ZLIB_LIB_DIR=${WORK_DIR}/zlib-1.2.11
	
	echo "the OpenSSL library"
	NGINX_OPEN_SSL_LIB_SRC="http://www.openssl.org/source/openssl-1.0.2f.tar.gz"
	wget -O- ${NGINX_OPEN_SSL_LIB_SRC} | tar xvz
	NGINX_OPEN_SSL_LIB_DIR=${WORK_DIR}/openssl-1.0.2f
	
	echo "Downloading nginx."
	wget -O- ${NGINX_SRC} | tar xvz
	cd ${NGINX_VER}
	echo "nginx already downloaded."
	
	echo "Configuring executable."
	./configure \
	 --prefix=${NGINX_PREFIX} \
	 --user=daemon \
	 --group=daemon \
	 --with-select_module \
	 --with-poll_module \
	 --with-threads \
	 --with-file-aio \
	 --with-http_ssl_module \
	 --with-http_v2_module \
	 --with-http_realip_module \
	 --with-http_addition_module \
	 --with-http_sub_module \
	 --with-http_dav_module \
	 --with-http_flv_module \
	 --with-http_mp4_module \
	 --with-http_gunzip_module \
	 --with-http_gzip_static_module \
	 --with-http_auth_request_module \
	 --with-http_random_index_module \
	 --with-http_secure_link_module \
	 --with-http_degradation_module \
	 --with-http_slice_module \
	 --with-http_stub_status_module \
	 --http-client-body-temp-path=${NGINX_CLIENT_BODY_TEMP} \
	 --http-proxy-temp-path=${NGINX_PROXY_TEMP} \
	 --http-fastcgi-temp-path=${NGINX_FASTCGI_TEMP} \
	 --http-uwsgi-temp-path=${NGINX_UWSGI_TEMP} \
	 --http-scgi-temp-path=${NGINX_SCGI_TEMP} \
	 --with-mail=dynamic \
	 --with-mail_ssl_module \
	 --without-mail_pop3_module \
	 --without-mail_imap_module \
	 --without-mail_smtp_module \
	 --with-stream=dynamic \
	 --with-stream_ssl_module \
	 --with-stream_realip_module \
	 --with-stream_ssl_preread_module \
		--with-pcre-jit \
	 --with-pcre=${NGINX_PCRE_LIB_DIR} \
	 --with-zlib=${NGINX_ZLIB_LIB_DIR} \
	 --with-openssl=${NGINX_OPEN_SSL_LIB_DIR}
	
	echo "Building executable."
	make -j`nproc` && make install
	echo 'export PATH="'${NGINX_PREFIX}'/sbin:$PATH"' >> ${HOME}/.bashrc
	reload_bashrc
	rm -rf ${NGINX_PCRE_LIB_DIR}
	rm -rf ${NGINX_ZLIB_LIB_DIR}
	rm -rf ${NGINX_OPEN_SSL_LIB_DIR}

	mkdir -p ${NGINX_CLIENT_BODY_TEMP}
	mkdir -p ${NGINX_PROXY_TEMP}
	mkdir -p ${NGINX_FASTCGI_TEMP}
	mkdir -p ${NGINX_UWSGI_TEMP}
	mkdir -p ${NGINX_SCGI_TEMP}

}