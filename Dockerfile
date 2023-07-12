FROM php:8.2-fpm-alpine3.17

ADD default.conf /etc/nginx/conf.d/
ADD index.php /var/www/html/
ADD run.sh /
ADD php.ini /usr/local/etc/php/
COPY application/ /var/www/html/application/

RUN apk update && \
    apk add --no-cache nginx libpng-dev libjpeg-turbo-dev freetype-dev libxml2-dev libxslt-dev libzip-dev oniguruma-dev && \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && \
    docker-php-ext-install -j$(nproc) zip xsl pdo_mysql

RUN mkdir /run/nginx && \
    touch /run/nginx/nginx.pid && \
    chmod 755 /run.sh

EXPOSE 80
EXPOSE 9000
ENTRYPOINT ["/run.sh"]
