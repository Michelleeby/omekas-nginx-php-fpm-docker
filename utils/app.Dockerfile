FROM php:8.2-fpm AS php
# Omeka S requires the PDO and PDO Mysql extensions.
RUN docker-php-ext-install mysqli pdo pdo_mysql
# Add the local php-fpm configuration file to the php-fpm container.
ADD ./config/php-fpm.conf /usr/local/etc/php-fpm.d/omekas.conf