#!/bin/bash
set -o pipefail

# Configurar permisos
chown -R www-data:www-data /var/www/wordpress

# Esperar a la base de datos
echo "Esperando conexión a MariaDB..."
while ! mysqladmin ping -hmariadb -u${MDB_USER} -p${MDB_USER_PASSWORD} --silent; do
    echo "Intentando conectar a MariaDB..."
    sleep 2
done
echo "Conexión a MariaDB establecida"

# Configurando WordPress
echo "Configurando WordPress..."

# Verificar y eliminar wp-config.php si existe
if [ -f "/var/www/wordpress/wp-config.php" ]; then
    echo "Eliminando wp-config.php existente..."
    rm -f /var/www/wordpress/wp-config.php
fi

# Crear wp-config.php nuevo
echo "Creando wp-config.php..."
cd /var/www/wordpress
wp config create \
    --dbname=${MDB_NAME} \
    --dbuser=${MDB_USER} \
    --dbpass=${MDB_USER_PASSWORD} \
    --dbhost=mariadb \
    --allow-root \
    --skip-check || true

# Agregar definiciones adicionales
echo "Añadiendo configuraciones adicionales a wp-config.php..."
if [ -f "/var/www/wordpress/wp-config.php" ]; then
    sed -i "/That's all, stop editing/i define('WP_HOME', '${WP_URL}');" /var/www/wordpress/wp-config.php
    sed -i "/That's all, stop editing/i define('WP_SITEURL', '${WP_URL}');" /var/www/wordpress/wp-config.php
fi

# Intentar instalar WordPress
echo "Instalando WordPress..."
wp core install \
    --url=${WP_URL} \
    --title="${WP_TITLE}" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --path=/var/www/wordpress \
    --allow-root \
    --skip-email || true

# Intentar crear usuario adicional
echo "Creando usuario adicional..."
wp user create \
    ${WP_USER_NAME} \
    ${WP_USER_EMAIL} \
    --user_pass=${WP_USER_PASSWORD} \
    --role=${WP_ROLE} \
    --path=/var/www/wordpress \
    --allow-root || true

echo "WordPress configurado correctamente"

# Iniciar PHP-FPM
echo "Iniciando PHP-FPM..."
exec php-fpm7.4 --nodaemonize
