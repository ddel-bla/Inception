#!/bin/bash
set -e

# Verificar si la base de datos ya está inicializada
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo ">>> Inicializando la base de datos MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Iniciar el servidor temporalmente
    echo ">>> Iniciando servidor temporalmente..."
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    
    # Esperar a que el servidor esté disponible
    until mysqladmin ping >/dev/null 2>&1; do
        echo ">>> Esperando a que el servidor MySQL esté disponible..."
        sleep 2
    done
    
    echo ">>> Configurando la base de datos..."
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MDB_NAME};
CREATE USER IF NOT EXISTS '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MDB_NAME}.* TO '${MDB_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO '${MDB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MDB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    
    # Comprobar los permisos para verificar
    echo ">>> Verificando permisos..."
    mysql -u root -p${MDB_ROOT_PASSWORD} -e "SELECT User, Host FROM mysql.user;"
    
    # Detener el servidor temporal
    echo ">>> Deteniendo servidor temporal..."
    mysqladmin -u root -p${MDB_ROOT_PASSWORD} shutdown
    
    echo ">>> Inicialización completada"
else
    echo ">>> La base de datos ya está inicializada"
fi

echo ">>> Iniciando MariaDB..."
exec mysqld_safe