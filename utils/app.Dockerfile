FROM php:8.2-fpm AS php
# Omeka S requires the PDO and PDO Mysql extensions.
RUN docker-php-ext-install mysqli pdo pdo_mysql
# ImageMagick is required for image processing.
RUN apt update && apt install -y libmagickwand-dev imagemagick
RUN pecl install imagick && docker-php-ext-enable imagick
# Optionally, install the vips extension for image processing.
RUN apt update && apt install -y libvips-dev
RUN pecl install vips && docker-php-ext-enable vips
# Add the Omeka S app to the container.
ADD ./app /usr/share/nginx/omekas
# Add the Omeka S app overrides to the container.
ADD ./src/application/src/File/Thumbnailer/Vips.php /usr/share/nginx/omekas/application/src/File/Thumbnailer/Vips.php
ADD ./src/application/src/Service/File/Thumbnailer/VipsFactory.php /usr/share/nginx/omekas/application/src/Service/File/Thumbnailer/VipsFactory.php
ADD ./src/modules /usr/share/nginx/omekas/modules
ADD ./src/themes /usr/share/nginx/omekas/themes
# Update the ownership of the Omeka S to the shared user, www-data.
RUN chown -R www-data:www-data /usr/share/nginx/omekas