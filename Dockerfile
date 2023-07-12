FROM php:7.3-fpm-alpine3.12
ADD default.conf /etc/nginx/conf.d/
ADD index.php /var/www/html/
ADD run.sh /
ADD php.ini /usr/local/etc/php/
COPY application/ /var/www/html/application/
RUN apk update && \
    apk add --no-cache nginx gmp-dev libpng-dev libjpeg-turbo-dev freetype-dev libxml2-dev libxslt-dev libzip-dev && \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gmp gd soap mbstring pdo pdo_mysql zip xsl && \
    mkdir /run/nginx && \
    touch /run/nginx/nginx.pid && \
    chmod 755 /run.sh && \
    apk del gmp-dev libpng-dev libjpeg-turbo-dev freetype-dev libxml2-dev libxslt-dev libzip-dev
EXPOSE 80
EXPOSE 9000

ENTRYPOINT ["/run.sh"]
