# 👋 welcome to your docker nginx mariadb php-fpm app
This is a framework for a local [Docker](https://www.docker.com/) web app. This example uses [Omeka S](https://omeka.org/s/) as an application base, with [NGINX](https://www.nginx.com/), [PHP-FPM](https://php-fpm.org/), and [MariaDB](https://mariadb.org/) powering the frontend and backend networks.

## Project framework and equivalent container locations

```
app / :/usr/share/nginx/app
src / :/usr/share/nginx/app
config /
    -   nginx.conf:/etc/nginx/nginx.conf
    -   nginx.app.conf:/etc/nginx/conf.d/app.conf
    -   php-fpm.conf:/usr/local/etc/php-fpm.d/app.conf
utils /
    -   web.Dockerfile
    -   app.Dockerfile
    -   ingest.Dockerfile
```
​
The `app` directory holds vendor application code, like the latest release of [Omeka S](https://github.com/omeka/omeka-s/releases/tag/v4.0.0). The `src` directory holds your local application code overrides. For example, Omeka S ships with a `/themes`, `/modules`, and `/files` directory. The contents of these directories,though, is unique to your application. To keep vendor application code and your project application code seperate, use the `src` directory and then aggregate the sources during the build step.

Configs are found in their own local [`configs`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/tree/main/config) directory. These are then mounted in the appropriate place using the `config` directive in [`compose.yaml`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/compose.yaml).

Finally, the [`utils`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/tree/main/utils) directory holds the Dockerfiles responsible for building the `web`, `app`, and optionally, the `ingest` images and containers.


## Basic usage

Add your vendor app code to the `app` and your local app code to the `src` directory. Please note that I've set `git` to ignore everything in these directories except the `.gitignore` file itself. Remove or adjust the directory's `.gitignore` file as needed.

Adjust [`compose.yaml`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/compose.yaml) and the build scripts, [`server.Dockerfile`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/server.Dockerfile) and [`app.Dockerfile`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/app.Dockerfile) as needed. You'll probably need to adjust the `ADD` lines to account for your own `app` and `src` code needs.

If you need to populate a volume for the first time with data, like if we had files we wanted in the `files` volume from the start, use the `ingest` service. In `ingest.Dockerfile` add the files and then mount them into the volume. When you spin up the container, it will add the files to the volume and then exit. You can then delete the container and image for the `ingest` service. When you don't need to ingest anything, comment out or remove `ingest` from `compose.yaml`. 

MariaDB relies on a local `.env` file for its environment definitions. So, create this `.env` file in your projects root and add your defintions, like:

```
MARIADB_ROOT_PASSWORD='rootpassword'
MARIADB_DATABASE='app'
MARIADB_USER='appuser'
MARIADB_PASSWORD='appuserpassword'
```

Once thats all done, run `docker compose up` from the projects root and your project should come alive ⚡️

Go to your [apps configured server name](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/config/nginx.app.conf#L7) in browser and see if it works 🤓

## More on [`compose.yaml`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/compose.yaml)

Here we define our project's stack, so to speak. This framework utilizes top level [services](https://docs.docker.com/compose/compose-file/#services-top-level-element), [networks](https://docs.docker.com/compose/compose-file/#networks-top-level-element), [volumes](https://docs.docker.com/compose/compose-file/#volumes-top-level-element), and [configs](https://docs.docker.com/compose/compose-file/#configs-top-level-element).

We establish two networks for our front and back end services to use.

```yaml
networks:
  frontend: {}
  backend: {}
```

We create as many volumes as our project needs. For this Omeka S example, I create volumes for files, sideload, logs, and db. Files, sideload, and logs are all the files that will be created by and shared accross the app and the web service. While the db is the persistant database data our app reads and writes to. 

```yaml
volumes:
  files: {}
  sideload: {}
  logs: {}
  db: {}
```

We define and point to as many configs as our project needs.

```yaml
configs:
  nginx.app.conf:
    file: ./config/nginx.app.conf
  nginx.conf:
    file: ./config/nginx.conf
  php-fpm.conf:
    file: ./config/php-fpm.conf
  fastcgi_params:
    file: ./config/fastcgi_params
  omekas-db.ini:
    file: ./config/omekas-db.ini
  omekas.vips.config.php:
    file: ./config/omekas.vips.config.php
  module.config.php:
    file: ./config/module.config.php
```

 At a minumum, you probably need...

```yaml
configs:
  nginx.app.conf:
    file: ./config/nginx.app.conf
  nginx.conf:
    file: ./config/nginx.conf
  php-fpm.conf:
    file: ./config/php-fpm.conf
```

...to properly define the NGINX and PHP-FPM user as well as any other settings specific to your app.

Bringing everything together, we have our services: `web`, `app`, and `db` that use our networks, volumes, and configs. 

```yaml
services:
  web: 
    build:
      dockerfile: ./utils/web.Dockerfile
    restart: always
    ports:
      - 80:80
    networks:
      - frontend
    volumes: 
      - files:/usr/share/nginx/omekas/files
      - sideload:/usr/share/nginx/omekas/sideload
      - logs:/usr/share/nginx/omekas/logs
    configs:
      - source: omekas-db.ini
        target: /usr/share/nginx/omekas/config/database.ini
      - source: omekas.vips.config.php
        target: /usr/share/nginx/omekas/config/local.config.php
      - source: module.config.php
        target: /usr/share/nginx/omekas/application/config/module.config.php
      - source: fastcgi_params
        target: /etc/nginx/fastcgi_params
      - source: nginx.app.conf
        target: /etc/nginx/conf.d/omekas.conf
      - source: nginx.conf
        target: /etc/nginx/nginx.conf

  app:
    build: 
      dockerfile: ./utils/app.Dockerfile
    restart: always
    ports:
      - 9000:9000
    networks:
      - frontend
      - backend
    volumes:
      - files:/usr/share/nginx/omekas/files
      - sideload:/usr/share/nginx/omekas/sideload
      - logs:/usr/share/nginx/omekas/logs
    configs:
      - source: omekas-db.ini
        target: /usr/share/nginx/omekas/config/database.ini
      - source: omekas.vips.config.php
        target: /usr/share/nginx/omekas/config/local.config.php
      - source: module.config.php
        target: /usr/share/nginx/omekas/application/config/module.config.php
      - source: php-fpm.conf
        target: /usr/local/etc/php-fpm.d/omekas.conf

  db:
    image: mariadb:latest
    restart: always
    ports: 
      - 3306:3306
    networks:
      - backend
    volumes:
      - db:/var/lib/mysql
    environment: 
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
      MARIADB_DATABASE: ${MARIADB_DATABASE}
      MARIADB_USER: ${MARIADB_USER}
      MARIADB_PASSWORD: ${MARIADB_PASSWORD}
```



## Check out the CLI framework 😄
Typing the same few commands over and over? Check out the included [CLI](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/tree/main/utils/cli) framework and throw in your most used [commands](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/cli/commands).  