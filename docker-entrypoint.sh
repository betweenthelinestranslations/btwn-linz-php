#!/bin/bash

set -e

mkdir -p /var/www/web
mkdir -p /files/temp
mkdir -p /files/public
mkdir -p /files/private
#ln -s /files/private /var/www/web/sites/default/private
#ln -s /files/public /var/www/web/sites/default/files
#ln -s /files/temp /var/www/web/sites/default/temp


php-fpm
