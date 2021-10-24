# The following Dockerfile is largely taken from https://github.com/fethica/jikan-rest-docker.

# Jikan API v3 might not fully support 7.4.
# Also, the official production instance uses 7.3.
FROM php:7.3-apache-buster

# Install git, unzip
RUN apt-get update && apt-get install -y git unzip

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the Apache config file
COPY 000-default.conf /etc/apache2/sites-available

# Add .htaccess rewrites and headers modules.
RUN a2enmod rewrite \
    && a2enmod headers \
    && service apache2 restart

# Pull source from git
RUN git clone https://github.com/jikan-me/jikan-rest.git .

# We need this for PHP 7.3. Otherwise, packages will complain about using Composer 2 with 7.4.
RUN composer require composer/package-versions-deprecated

# Update and install dependencies
RUN composer update --prefer-dist --prefer-stable  --no-progress --no-interaction
RUN composer install --prefer-dist --no-dev --no-progress --classmap-authoritative

# Environment
ENV APP_ENV=production
ENV APP_DEBUG=false

# Since we're running on Railway (no persistent files yet)
ENV CACHE_DRIVER=redis
ENV QUEUE_CONNECTION=redis

# TODO: Implement queue cache method
ENV CACHE_METHOD=legacy

COPY ./run-jikan.sh .
RUN chmod +x ./run-jikan.sh

# If we use ENTRYPOINT here, `docker run` must be run with `--init`.
# We don't want that, especially because Railway does not do that.
CMD ["./run-jikan.sh"]
