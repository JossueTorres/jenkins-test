# Tomando de base la imagen de ubuntu
FROM ubuntu:18.04 

#Actualizamos
RUN apt-get update \ 
    && apt-get upgrade

#Comandos para instalar apache2
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y  apache2

#Comandos para instalar php
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y php libapache2-mod-php php-fpm

#Comandos para instalar Extensiones de php    
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y php-mysql php-gd \
    && a2enmod proxy_fcgi setenvif && a2enconf php7.2-fpm

#Crear archivo de prueba php
RUN touch /var/www/html/info.php \ 
    && echo '<?php phpinfo();' >> /var/www/html/info.php

# allow .htaccess with RewriteEngine
RUN a2enmod rewrite

# to see live logs we do : docker logs -f [CONTAINER ID]
# without the following line we get 
#"AH00558: apache2: Could not reliably determine the server's fully qualified domain name"
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# autorise .htaccess files
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN chgrp -R www-data /var/www
RUN find /var/www -type d -exec chmod 775 {} +
RUN find /var/www -type f -exec chmod 664 {} +

#Copiamos los comandos parta mysql de wordpress
COPY Crear_base_wordpress_default.sql /temp/Crear_base_wordpress_default.sql

#Comandos para instalar mySQL
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y mysql-server mysql-client
RUN chown -R mysql:mysql /var/lib/mysql /var/run/ \
    && service mysql start \
    && mysql -h localhost -P 3306  < "/temp/Crear_base_wordpress_default.sql"

#Copiamos la carpeta a la carpeta /var/www/html/

#Expondremos el puerto 80
EXPOSE 80

CMD ["/usr/sbin/apache2ctl","-DFOREGROUND"]
#CMD ["/bin/bash"]