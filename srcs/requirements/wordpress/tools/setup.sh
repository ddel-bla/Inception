#!/bin/bash
set -eo pipefail

# Configurar permisos
chown -R www-data:www-data /var/www/wordpress

# Esperar a la base de datos
echo "Esperando conexión a MariaDB..."
while ! mysqladmin ping -hmariadb -u${MDB_USER} -p${MDB_USER_PASSWORD} --silent; do
    echo "Intentando conectar a MariaDB..."
    sleep 2
done
echo "Conexión a MariaDB establecida"

# Verificar si WordPress ya está instalado
if wp core is-installed --path=/var/www/wordpress --allow-root; then
    echo "WordPress ya está instalado, omitiendo configuración inicial"
else
    echo "Configurando WordPress..."
    
    # Verificar si wp-config.php ya existe
    if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
        echo "Creando wp-config.php..."
        wp config create \
            --dbname=${MDB_NAME} \
            --dbuser=${MDB_USER} \
            --dbpass=${MDB_USER_PASSWORD} \
            --dbhost=mariadb \
            --path=/var/www/wordpress \
            --allow-root \
            --extra-php <<PHP
define('WP_HOME', '${WP_URL}');
define('WP_SITEURL', '${WP_URL}');
PHP
    else
        echo "wp-config.php ya existe"
    fi

    # Instalar WordPress
    echo "Instalando WordPress..."
    wp core install \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --path=/var/www/wordpress \
        --allow-root

    # Crear usuario adicional
    echo "Creando usuario adicional..."
    wp user create \
        ${WP_USER_NAME} \
        ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=${WP_ROLE} \
        --path=/var/www/wordpress \
        --allow-root
fi

echo "WordPress configurado correctamente"

# Iniciar PHP-FPM
echo "Iniciando PHP-FPM..."
exec php-fpm7.4 --nodaemonize