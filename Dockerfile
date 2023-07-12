FROM php:8.2-fpm-alpine3.17

ADD default.conf /etc/nginx/conf.d/
ADD index.php /var/www/html/
ADD run.sh /
ADD php.ini /usr/local/etc/php/
COPY application/ /var/www/html/application/

RUN apk update && apk add nginx && \
    apk add m4 autoconf make gcc g++ linux-headers && \
    docker-php-ext-install pdo_mysql opcache mysqli && \
	pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis && \
    mkdir /run/nginx && \
    mv /default.conf /etc/nginx/conf.d && \
    mv /index.php /var/www/html && \
    touch /run/nginx/nginx.pid && \
    chmod 755 /run.sh && \
    apk del m4 autoconf make gcc g++ linux-headers

EXPOSE 80
EXPOSE 9000
ENTRYPOINT ["/run.sh"]
