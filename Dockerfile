ARG PHP_VERSION=php-8.0


# Build the Docker image for Drupal.
FROM ghcr.io/demigod-tools/php:$PHP_VERSION

RUN apt-get update -y \
    && apt-get upgrade -y  \
    && apt-get install  \
      iputils-ping \
      nginx \
      libfcgi0ldbl  \
      telnet \
      vim -y

LABEL org.label-schema.vendor="demigod-tools" \
  org.label-schema.name=$REPO_NAME \
  org.label-schema.description="Prettier is an opinionated code formatter." \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$VERSION \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/$REPO_NAME" \
  org.label-schema.usage="https://github.com/$REPO_NAME/blob/master/README.md#usage" \
  org.label-schema.docker.cmd="docker run --rm -v \$PWD:/work $REPO_NAME --parser=markdown --write '**/*.md'" \
  org.label-schema.schema-version="1.0"

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Add Drush Launcher.
RUN curl -OL https://github.com/drush-ops/drush-launcher/releases/download/0.10.1/drush.phar \
 && chmod +x drush.phar \
 && mv drush.phar /usr/local/bin/drush \
 && curl -sSL https://sdk.cloud.google.com | bash

RUN rm -Rf /usr/local/etc/conf.d
COPY php /usr/local/etc
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY init /opt/init

RUN chmod +x /docker-entrypoint.sh && chmod +x /opt/init

# Copy other required configuration into the container.
# Make sure file ownership is correct on the document root.
RUN chown -R www-data:www-data /var/www/web  \
    && rm -Rf /var/www/html  \
    && ln -s /var/www/web /var/www/html \
    && mkdir -p /files/bucket-data \
    && mkdir -p /secrets/db \
    && echo "<?php phpinfo(); " >> /var/www/web/index.php \
    && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /cloud_sql_proxy \
    && chmod +x /cloud_sql_proxy

STOPSIGNAL SIGQUIT

WORKDIR /var/www

EXPOSE 9000
ENTRYPOINT [ "/docker-entrypoint.sh"]
CMD [ "/usr/bin/supervisord","-c", "/etc/supervisor/supervisord.conf:" ]

