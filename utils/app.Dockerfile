FROM php:8.2-fpm AS php
# Install the PHP extensions installer script and PHP extensions.
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN apt update && apt install -y libmagickwand-dev imagemagick
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions mysqli pdo pdo_mysql imagick vips solr xdebug
# Add Omeka S app to the container.
ADD ./app /usr/share/nginx/omekas
# Add Omeka S app overrides to the container.
ADD ./src/application/src/File/Thumbnailer/Vips.php /usr/share/nginx/omekas/application/src/File/Thumbnailer/Vips.php
ADD ./src/application/src/Service/File/Thumbnailer/VipsFactory.php /usr/share/nginx/omekas/application/src/Service/File/Thumbnailer/VipsFactory.php
ADD ./src/modules /usr/share/nginx/omekas/modules
ADD ./src/themes /usr/share/nginx/omekas/themes
# Update the ownership of Omeka S to the app and web service user, www-data.
RUN chown -R www-data:www-data /usr/share/nginx/omekas
