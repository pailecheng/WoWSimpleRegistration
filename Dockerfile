FROM php:7.3-fpm-alpine3.11

# 添加 GMP 扩展的依赖项
RUN apk add --no-cache gmp-dev

# 安装 GMP 扩展
RUN docker-php-ext-install gmp

# 安装 GD 相关依赖项，包括 libpng、libjpeg 和 freetype
RUN apk add --no-cache libpng-dev libjpeg-turbo-dev freetype-dev libwebp-dev zlib-dev

# 链接动态库
RUN ln -s /usr/include/libpng16 /usr/include/png

# 配置并安装 GD 扩展，指定所需的库路径和选项
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ --with-png-dir=/usr/include/ --with-webp=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd

# 其他指令继续保持不变
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

