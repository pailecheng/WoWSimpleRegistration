FROM php:7.3-fpm-alpine3.11
RUN apk add --no-cache gmp-dev
RUN docker-php-ext-install gmp
ADD default.conf /etc/nginx/conf.d/
ADD index.php /var/www/html/
ADD run.sh /
ADD php.ini /usr/local/etc/php/
COPY application/ /var/www/html/application/
RUN apk update && \
    apk add nginx && \
    apk add m4 autoconf make gcc g++ linux-headers && \
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
