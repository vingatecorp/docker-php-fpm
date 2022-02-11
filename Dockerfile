FROM php:8.1-fpm
MAINTAINER "vingate" <dev.vadym@gmail.com>


ARG TZ='Europe/Kiev'

RUN apt-get update

RUN echo "${TZ}" && apt-get install -y tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone


RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
            curl libxml2-dev git supervisor nodejs npm ffmpeg openssl \
            libxml2-dev  \
            libmemcached-dev \
            libz-dev \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
            libfreetype6-dev \
            libssl-dev \
            libwebp-dev \
            libxpm-dev \
            libmcrypt-dev \
            libonig-dev


#install some base extensions
RUN apt-get install -y \
        libzip-dev \
        zlib1g-dev \
        zip \
    && docker-php-ext-install zip


RUN docker-php-ext-install mysqli && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install exif


RUN docker-php-ext-configure gd \
            --prefix=/usr \
            --with-jpeg \
            --with-webp \
            --with-freetype
RUN docker-php-ext-install -j$(nproc) gd


RUN pecl install -o -f redis mongodb \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
    &&  docker-php-ext-enable mongodb


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


WORKDIR /var/www/
