FROM php:7.3-fpm-alpine3.11

ADD default.conf /etc/nginx/conf.d/
ADD index.php /var/www/html/
ADD run.sh /
ADD php.ini /usr/local/etc/php/
COPY application/loader.php /var/www/html/application/
COPY application/vendor/autoload.php /var/www/html/application/vendor/
COPY application/config/config.php /var/www/html/application/config/
COPY application/include/core_handler.php /var/www/html/application/include/
COPY application/include/functions.php /var/www/html/application/include/
COPY application/include/database.php /var/www/html/application/include/
COPY application/include/user.php /var/www/html/application/include/
COPY application/include/vote.php /var/www/html/application/include/
COPY application/include/status.php /var/www/html/application/include/
RUN apk update && \
    apk add nginx && \
    apk add m4 autoconf make gcc g++ linux-headers && \
    docker-php-ext-install pdo_mysql opcache mysqli && \
    pecl install -o -f redis && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable redis && \
    mkdir /run/nginx && \
    touch /run/nginx/nginx.pid && \
    chmod 755 /run.sh && \
    apk del m4 autoconf make gcc g++ linux-headers
EXPOSE 80
EXPOSE 9000

ENTRYPOINT ["/run.sh"]
