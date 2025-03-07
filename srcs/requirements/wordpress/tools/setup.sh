#!/bin/bash
set -eo pipefail

# Configurar permisos
chown -R www-data:www-data /var/www/wordpress

# Esperar a la base de datos
while ! mysqladmin ping -hdb -u${MDB_USER} -p${MDB_USER_PASSWORD} --silent; do
	sleep 2
done

# Instalar WordPress si no existe
if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	wp core download --path=/var/www/wordpress --allow-root
	wp config create \
		--dbname=${MDB_NAME} \
		--dbuser=${MDB_USER} \
		--dbpass=${MDB_USER_PASSWORD} \
		--dbhost=mariadb
		--path=/var/www/wordpress \
		--allow-root \
		--extra-php <<PHP
define('WP_HOME', '${WP_URL}');
define('WP_SITEURL', '${WP_URL}');
PHP
fi

# Instalar sitio
if ! wp core is-installed --path=/var/www/wordpress --allow-root; then
	wp core install \
		--url=${WP_URL} \
		--title="${WP_TITLE}" \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--path=/var/www/wordpress \
		--allow-root
fi

# Crear usuario adicional
if ! wp user get ${WP_USER_NAME} --path=/var/www/wordpress --allow-root &>/dev/null; then
	wp user create \
		${WP_USER_NAME} \
		${WP_USER_EMAIL} \
		--user_pass=${WP_USER_PASSWORD} \
		--role=${WP_ROLE} \
		--path=/var/www/wordpress \
		--allow-root
fi

# Iniciar PHP-FPM
exec php-fpm7.4 --nodaemonize
