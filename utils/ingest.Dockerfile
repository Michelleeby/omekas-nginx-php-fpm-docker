FROM alpine:latest as alpine
# Ingest ./src/sideload into /usr/share/nginx/omekas/sideload to populate the sideload volume.
ADD --chown=www-data:www-data ./src/sideload /usr/share/nginx/omekas/sideload