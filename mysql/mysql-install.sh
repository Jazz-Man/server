#!/usr/bin/env bash


build_mysql() {
	cd ${WORK_DIR}
	MYSQL_VER='10.1.21'
	MYSQL_SRC="https://ftp.heanet.ie/mirrors/mariadb/mariadb-${MYSQL_VER}/source/mariadb-${MYSQL_VER}.tar.gz"
	MYSQL_PREFIX=${INSTALLDIR}/mysql
	MYSQL_ETC_PREFIX=${MYSQL_PREFIX}/etc
	MYSQL_DATA_DIR=${MYSQL_PREFIX}/data
	MYSQL_TMP_DIR=${MYSQL_PREFIX}/tmp
	CMAKE_BIN=${COMMON_DIR}/cmake/bin/cmake
#	wget -O- ${MYSQL_SRC} | tar xvz
#	cd mariadb-${MYSQL_VER}
	
#	$CMAKE_BIN \
#  -DCMAKE_INSTALL_PREFIX=${MYSQL_PREFIX} \
#  -DMYSQL_DATADIR=${MYSQL_DATA_DIR} \
#  -DMYSQL_UNIX_ADDR=${MYSQL_TMP_DIR}/mysqld.sock \
#  -DDEFAULT_CHARSET=utf8mb4 \
#  -DDEFAULT_COLLATION=utf8mb4_unicode_ci \
#  -DINSTALL_DOCDIR=share/doc \
#  -DINSTALL_DOCREADMEDIR=share/doc \
#  -DINSTALL_MANDIR=share/man \
#  -DINSTALL_PLUGINDIR=lib/plugin \
#  -DINSTALL_SCRIPTDIR=bin \
#  -DINSTALL_SYSCONFDIR=${MYSQL_ETC_PREFIX} \
#  -DINSTALL_SYSCONF2DIR=${MYSQL_ETC_PREFIX} \
#  -DINSTALL_INCLUDEDIR=${MYSQL_PREFIX}/include \
#  -DINSTALL_SUPPORTFILESDIR=${MYSQL_PREFIX}/share \
#  -DINSTALL_MYSQLSHAREDIR=${MYSQL_PREFIX}/share \
#  -DINSTALL_SHAREDIR=${MYSQL_PREFIX}/share \
	
#		make -j`nproc` && make install
	
	cd ${MYSQL_PREFIX}/scripts
		./mysql_install_db \
			--basedir=${MYSQL_PREFIX} \
			--datadir=${MYSQL_PREFIX}/data \
			--force \
			--ldata=${MYSQL_PREFIX}/data \
			--defaults-file=${MYSQL_PREFIX}/my.cnf
}