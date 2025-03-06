#!/bin/bash
set -eo pipefail

mysqld_safe --skip-networking &

echo "Waiting for MariaDB to start..."
until mysqladmin ping &>/dev/null; do
  sleep 1
done

mysql  <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MDB_ROOT_PASSWORD}';
CREATE IF NOT EXISTS DATABASE ${MDB_NAME};
CREATE IF NOT EXISTS USER '${MDB_USER}'@'%' IDENTIFIED BY '${MDB_USER_PASSWORD}';
GRANT ALL ON ${MDB_NAME}.* TO '${MDB_USER}'@'%';
EOF

mysqladmin --user=root --password="${MDB_ROOT_PASSWORD}" shutdown

exec mysqld_safe