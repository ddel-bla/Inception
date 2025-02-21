FROM debian:bullseye

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios necesarios
RUN mkdir -p \
    /var/lib/nginx/body \
    /var/lib/nginx/fastcgi \
    /var/lib/nginx/proxy \
    /var/lib/nginx/uwsgi \
    /etc/nginx/ssl \
    /var/run/nginx

# Generar certificados autofirmados
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=Company/CN=ddel-bla.42.fr" \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Configurar usuario y permisos
RUN useradd -r nginx-user \
    && chown -R nginx-user:nginx-user \
        /var/lib/nginx \
        /var/run/nginx \
        /etc/nginx/ssl \
        /var/log/nginx \
    && chmod 755 /var/lib/nginx

USER nginx-user

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]