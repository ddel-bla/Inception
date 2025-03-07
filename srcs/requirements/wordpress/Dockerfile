FROM debian:bullseye

# Instalar dependencias específicas de PHP 7.4
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    default-mysql-client \
    wget \
    tar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio necesario para WordPress
RUN mkdir -p /var/www/wordpress

# Descargar y extraer WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz --strip-components=1 -C /var/www/wordpress \
    && rm latest.tar.gz

# Copiar configuración de PHP-FPM
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Crear el usuario wp-user y dar permisos adecuados
RUN useradd -r wp-user \
    && chown -R wp-user:wp-user /var/www/wordpress \
    && chmod -R 755 /var/www/wordpress

# Crear directorio de ejecución de PHP
RUN mkdir -p /run/php && chmod 777 /run/php

# Copiar wp-config.php con las variables de entorno
COPY conf/wp-config.php /var/www/wordpress/wp-config.php

# Exponer el puerto 9000 para PHP-FPM
EXPOSE 9000

# Copiar y hacer ejecutable el script de configuración
COPY ./tools/setup.sh /
RUN chmod +x /setup.sh

# Comando para iniciar el contenedor
ENTRYPOINT [ "/bin/bash", "/setup.sh" ]