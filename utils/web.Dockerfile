FROM nginx:latest as nginx
# Add Omeka S app files to the container.
ADD ./app /usr/share/nginx/omekas
# Add Omeka S app overrides to the container.
ADD ./src/modules /usr/share/nginx/omekas/modules
ADD ./src/themes /usr/share/nginx/omekas/themes
ADD ./src/application/src/File/Thumbnailer/Vips.php /usr/share/nginx/omekas/application/src/File/Thumbnailer/Vips.php
ADD ./src/application/src/Service/File/Thumbnailer/VipsFactory.php /usr/share/nginx/omekas/application/src/Service/File/Thumbnailer/VipsFactory.php
# Update the ownership of Omeka S to the shared user, www-data.
RUN chown -R www-data:www-data /usr/share/nginx/omekas