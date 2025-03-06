FROM debian:bullseye

# Instalar MariaDB y dependencias necesarias
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar la configuración de MariaDB
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/

# Copiar el script de inicio
COPY tools/startup.sh /bin/

# Asegurar permisos del script de inicio
RUN chmod +x /bin/startup.sh

# Exponer el puerto 3306 de MariaDB
EXPOSE 3306

# Comando para iniciar MariaDB
ENTRYPOINT [ "/bin/bash", "/bin/startup.sh" ]