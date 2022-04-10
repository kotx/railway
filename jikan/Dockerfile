FROM php:8.0-apache-buster

# Copy the Apache config file
COPY 000-default.conf /etc/apache2/sites-available

# Add .htaccess rewrites and headers modules.
RUN a2enmod rewrite \
    && a2enmod headers

RUN apt-get update && apt-get install -y git unzip build-essential pkg-config libssl-dev
RUN pecl install mongodb && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/docker-php-ext-mongodb.ini

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo "* * * * * cd /var/www/jikan-rest && php artisan schedule:run >> /dev/null 2>&1" >> /etc/crontab

WORKDIR /var/www/jikan-rest

# Pull source from git
RUN git clone --depth=1 https://github.com/jikan-me/jikan-rest.git .

# Update and install dependencies
RUN composer update --prefer-dist --prefer-stable  --no-progress --no-interaction
RUN composer install --prefer-dist --no-dev --no-progress --classmap-authoritative

# Environment
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV SOURCE=local

ENV DB_CACHING=true
ENV DB_CONNECTION=mongodb

## Use Redis
ENV CACHING=true
ENV CACHE_DRIVER=redis
ENV CACHE_METHOD=queue
ENV QUEUE_CONNECTION=redis

# Jikan needs permissions to write to logs & such
RUN chmod -R a+w /var/www/jikan-rest/storage

COPY ./run-jikan.sh .
RUN chmod +x ./run-jikan.sh

# If we use ENTRYPOINT here, `docker run` must be run with `--init`.
# We don't want that, especially because Railway does not do that.
CMD ["./run-jikan.sh"]
