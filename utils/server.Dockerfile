FROM nginx:latest AS nginx
# Add the nginx configuration file for the omekas application server.
ADD ./config/nginx.app.conf /etc/nginx/conf.d/omekas.conf
# Add the omekas application files to the nginx server.
ADD ./app /usr/share/nginx/omekas
