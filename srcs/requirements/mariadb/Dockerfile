FROM debian:bullseye

# Instalar MariaDB y dependencias necesarias
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios críticos con permisos adecuados
RUN mkdir -p /var/run/mysqld \
    && mkdir -p /var/lib/mysql \
    && chown -R mysql:mysql /var/run/mysqld /var/lib/mysql \
    && chmod 777 /var/run/mysqld /var/lib/mysql

# Copiar la configuración de MariaDB
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/

# Copiar el script de inicio
COPY tools/startup.sh /tmp/

# Asegurar permisos del script de inicio
RUN chmod +x /tmp/startup.sh

# Exponer el puerto 3306 de MariaDB
EXPOSE 3306

# Usar el usuario mysql para ejecutar el contenedor
USER mysql

# Volumen persistente para datos de la base de datos
VOLUME /var/lib/mysql

# Comando para iniciar MariaDB
CMD ["/tmp/startup.sh"]
