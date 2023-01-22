FROM php:8.2-fpm AS php
# Add the Omeka S app to the container.
ADD --chown=www-data:www-data ./app /usr/share/nginx/omekas
# Add the Omeka S app overrides to the container.
ADD --chown=www-data:www-data ./src/modules /usr/share/nginx/omekas/modules
ADD --chown=www-data:www-data ./src/themes /usr/share/nginx/omekas/themes
ADD --chown=www-data:www-data ./src/application/src/File/Thumbnailer/Vips.php /usr/share/nginx/omekas/application/src/File/Thumbnailer/Vips.php
ADD --chown=www-data:www-data ./src/application/src/Service/File/Thumbnailer/VipsFactory.php /usr/share/nginx/omekas/application/src/Service/File/Thumbnailer/VipsFactory.php
# Add the local Omeka S app /files directory to the ontainer.
ADD --chown=www-data:www-data ./src/files /usr/share/nginx/omekas/files
# Omeka S requires the PDO and PDO Mysql extensions.
RUN docker-php-ext-install mysqli pdo pdo_mysql
# ImageMagick is required for image processing.
RUN apt update && apt install -y libmagickwand-dev imagemagick
RUN pecl install imagick && docker-php-ext-enable imagick
# Optionally, install the vips extension for image processing.
RUN apt update && apt install -y libvips-dev
RUN pecl install vips && docker-php-ext-enable vips