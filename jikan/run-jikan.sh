sed -ri -e "s/Listen 80[[:space:]]*$/Listen $PORT/" /etc/apache2/ports.conf

#php artisan migrate
docker-php-entrypoint apache2-foreground
