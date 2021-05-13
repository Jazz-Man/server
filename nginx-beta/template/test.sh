#!/usr/bin/env sh

[ $PHP_FPM_FRONTEND_PORT != "false" ] && echo "127.0.0.1:$PHP_FPM_FRONTEND_PORT" || echo "unix:$VAR_PREFIX/php-fpm-frontend.sock";