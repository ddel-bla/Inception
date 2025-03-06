FROM debian:bullseye

# Instalar dependencias específicas de la versión PHP 7.4
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
	default-mysql-client \
    wget \
	tar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio necesario para WordPress
RUN mkdir -p /var/www/html

# Descargar y extraer WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz --strip-components=1 -C /var/www/html \
    && rm latest.tar.gz

# Copiar configuración de PHP-FPM (ajustada para usuario no root)
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Configurar permisos y usuario
RUN useradd -r wp-user \
    && chown -R wp-user:wp-user /var/www/html \
    && chmod -R 755 /var/www/html

# Permisos críticos para /run/php
RUN mkdir -p /run/php && chmod 777 /run/php

# Copiar wp-config.php con variables de entorno
COPY conf/wp-config.php /var/www/html/wp-config.php

# Exponer el puerto 9000 para PHP-FPM
EXPOSE 9000

# Comando para iniciar PHP-FPM en primer plano
COPY ./tools/setup.sh /

RUN chmod +x /setup.sh

ENTRYPOINT [ "/bin/bash", "/setup.sh" ]