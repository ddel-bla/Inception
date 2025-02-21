#!/bin/bash

# Crear directorio runtime
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld

# Inicializar DB si es primera vez
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Iniciar MySQL temporalmente sin red
    mysqld_safe --datadir=/var/lib/mysql --user=mysql --skip-networking &
    sleep 5
    
    # Configurar contraseña de root
    mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    
    # Detener MySQL temporal
    mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown
fi

# Iniciar MySQL en background
mysqld_safe --datadir=/var/lib/mysql --user=mysql &
sleep 5

# Validar nombre de usuario administrador
if echo "${DB_ADMIN_USER}" | grep -i -E 'admin|administrator' >/dev/null; then
    echo "Error: El nombre de usuario administrador no debe contener 'admin' o 'administrator'."
    exit 1
fi

# Configurar base de datos y usuarios
mysql -uroot -p${MYSQL_ROOT_PASSWORD} <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='root' AND Host='%';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
EOF

# Reiniciar MySQL en primer plano
mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown
exec mysqld_safe --datadir=/var/lib/mysql --user=mysql --console