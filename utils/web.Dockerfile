FROM nginx:latest as nginx
# Add the Omeka S app files to the container.
ADD --chown=www-data:www-data ./app /usr/share/nginx/omekas
# Add Omeka S app overrides to the container.
ADD --chown=www-data:www-data ./src/modules /usr/share/nginx/omekas/modules
ADD --chown=www-data:www-data ./src/themes /usr/share/nginx/omekas/themes
ADD --chown=www-data:www-data ./src/application/src/File/Thumbnailer/Vips.php /usr/share/nginx/omekas/application/src/File/Thumbnailer/Vips.php
ADD --chown=www-data:www-data ./src/application/src/Service/File/Thumbnailer/VipsFactory.php /usr/share/nginx/omekas/application/src/Service/File/Thumbnailer/VipsFactory.php
# Add the local Omeka S app /files directory to the container.
ADD --chown=www-data:www-data ./src/files /usr/share/nginx/omekas/files