#!/bin/bash
# Script sin comprobaciones de primera ejecución

echo ">>> Inicializando MariaDB si es necesario..."
mysql_install_db --user=mysql --datadir=/var/lib/mysql 2>/dev/null || true

# Configurar opciones de seguridad
echo ">>> Configurando seguridad MariaDB..."
cat > /etc/mysql/mariadb.conf.d/60-secure.cnf << EOF
[mysqld]
skip-networking=0
bind-address=0.0.0.0
EOF

# Iniciar el servidor temporalmente
echo ">>> Iniciando servidor temporalmente..."
/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

# Esperar a que el servidor esté disponible
until mysqladmin ping >/dev/null 2>&1; do
    echo ">>> Esperando a que el servidor MySQL esté disponible..."
    sleep 2
done

echo ">>> Configurando la base de datos..."
# Intentamos configurar sin contraseña primero (primera ejecución)
mysql -u root 2>/dev/null << EOF || true
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS ${MDB_NAME};
CREATE USER IF NOT EXISTS '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MDB_NAME}.* TO '${MDB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MDB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Intentamos configurar con la contraseña (ejecuciones posteriores)
mysql -u root -p${MDB_ROOT_PASSWORD} 2>/dev/null << EOF || true
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS ${MDB_NAME};
CREATE USER IF NOT EXISTS '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MDB_NAME}.* TO '${MDB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Intentamos detener el servidor temporal
echo ">>> Deteniendo servidor temporal..."
mysqladmin -u root shutdown 2>/dev/null || mysqladmin -u root -p${MDB_ROOT_PASSWORD} shutdown 2>/dev/null || echo ">>> No se pudo detener el servidor, pero continuaremos..."

echo ">>> Iniciando MariaDB..."
exec mysqld_safe
