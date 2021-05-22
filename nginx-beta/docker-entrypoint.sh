#!/usr/bin/env sh


cd /template-nginx

esh -o $NGINX_CONF_PREFIX/nginx.conf nginx.conf
esh -o $NGINX_CONF_PREFIX/sites-available/default.conf default.conf

chown -R $WWW_USER:$WWW_USER_GROUP $NGINX_CONF_PREFIX