FROM debian:bullseye

# Instalar dependencias específicas de PHP 7.4 y WP-CLI
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-soap \
    php7.4-xml \
    php7.4-zip \
    default-mysql-client \
    wget \
    tar \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Crear directorio necesario para WordPress
RUN mkdir -p /var/www/wordpress

# Descargar y extraer WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz --strip-components=1 -C /var/www/wordpress \
    && rm latest.tar.gz

# Copiar configuración de PHP-FPM
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Configurar permisos adecuados
RUN chown -R www-data:www-data /var/www/wordpress \
    && chmod -R 755 /var/www/wordpress

# Crear directorio de ejecución de PHP
RUN mkdir -p /run/php && chown www-data:www-data /run/php

# Copiar wp-config.php con las variables de entorno
COPY conf/wp-config.php /var/www/wordpress/wp-config.php
RUN chown www-data:www-data /var/www/wordpress/wp-config.php

# Exponer el puerto 9000 para PHP-FPM
EXPOSE 9000

# Copiar y hacer ejecutable el script de configuración
COPY ./tools/setup.sh /
RUN chmod +x /setup.sh

# Comando para iniciar el contenedor
ENTRYPOINT ["/bin/bash", "/setup.sh"]