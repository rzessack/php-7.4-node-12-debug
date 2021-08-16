FROM php:7.4-fpm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    libzip-dev \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    whois \
    netbase

RUN docker-php-ext-configure \
    zip \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install \
    zip \
    gd

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo 'date.timezone = "Europe/Moscow"\n' > /usr/local/etc/php/conf.d/timezone.ini

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && mkdir /var/www/.composer \
    && chown www-data:www-data /var/www/.composer

RUN curl https://phar.phpunit.de/phpunit-7.phar -L -o phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn \
    && mkdir /var/www/.yarn \
    && mkdir /var/www/.cache \
    && touch /var/www/.yarnrc \
    && chown www-data:www-data /var/www/.yarn \
    && chown www-data:www-data /var/www/.yarnrc \
    && chown www-data:www-data /var/www/.cache
    
RUN usermod -u 1000 www-data

WORKDIR /var/www/src

CMD ["php-fpm"]
