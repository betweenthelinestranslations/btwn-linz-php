#!/bin/bash

set -e

mkdir -p /var/www/web
mkdir -p /files/temp
mkdir -p /files/public
mkdir -p /files/private

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf


