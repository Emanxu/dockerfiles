FROM webdevops/php-nginx:7.3-alpine

LABEL maintainer="john@babayaga"

COPY ./default.conf /opt/docker/etc/nginx/vhost.conf
#COPY ./vmq/ /app/

WORKDIR /app

RUN set -xe \
    && git clone https://github.com/PoorThatcher/vmqphp.git \
    && chmod -R 755 /app/vmqphp \
    && mkdir -p /app/vmqphp/log \
    && touch /app/vmqphp/log/access.log \
    && touch /app/vmqphp/log/error.log \
    && chmod 777 /app/vmqphp/public/qr-code/test.php
