#!/bin/bash

mysqld_safe --skip-networking &
sleep 5  # Esperar a que inicie correctamente

mariadb -v -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASS_ROOT';
DELETE FROM mysql.user WHERE User='root' AND Host='%';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
EOF


mysqladmin -uroot -p$DB_PASS_ROOT shutdown


exec mysqld_safe
