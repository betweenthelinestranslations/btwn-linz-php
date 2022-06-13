#!/bin/bash

set -e

mkdir -p /var/www/web
mkdir -p /files/temp
mkdir -p /files/public
mkdir -p /files/private
/opt/init &> /proc/self/fd/2 & disown

nginx
php-fpm
