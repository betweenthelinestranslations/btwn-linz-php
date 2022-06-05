#!/bin/bash

set -e

if [[ -n "${GITCLONE_URL}" ]]; then
  cd /var
  rm -Rf /var/www
  ## URL should look like this: https://${TOKEN}:x-oauth-basic@github.com/MyUser/MyRepo.git
  git clone "${GITCLONE_URL}" www
fi

php-fpm
