# Jikan needs permissions to write to logs & such
chmod -R a+w storage/

# Re-export Redis configuration from Railway env
export REDIS_HOST=$REDISHOST
export REDIS_PASSWORD=$REDISPASSWORD
export REDIS_PORT=$REDISPORT

sed -ri -e "s/Listen 80[[:space:]]*$/Listen $PORT/" /etc/apache2/ports.conf

docker-php-entrypoint apache2-foreground
