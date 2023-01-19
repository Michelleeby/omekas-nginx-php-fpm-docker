# 👋 welcome to your docker nginx mariadb php-fpm app
This is a framework for a docker web app that uses Omeka S as an application base with Nginx, PHP-FPM, and MariaDB. 
​
## General framework and mounts

```
db  / :/var/lib/mysql
app / :/usr/share/nginx/app
src / 
    --- themes  / :/usr/share/nginx/app/themes
    --- modules / :/usr/share/nginx/app/modules
    --- files   / :/usr/share/nginx/app/files
config /
    --- omekas-db.ini:/usr/share/nginx/omekas/config/database.ini
    --- omekas.config.php:/usr/share/nginx/omekas/local.config.php
    --- php-fpm.conf:/usr/local/etc/php-fpm.d/omekas.conf
utils /
    --- server.Dockerfile
    --- app.Dockerfile
    --- cli /
```
​
The `app` and `src` directories are dependendent on your web app of choice. Here the app was a pre release copy of [Omeka S](https://github.com/omeka/omeka-s/releases/tag/v4.0.0-rc). 

Since Omeka S has a `/files`, `/themes`, and `/modules` directory, it made sense to mount those in my `src` directory. Files you want easy local access to, like themes or files, I find helpful to mount. 

Configs are also mounted in their own `configs` directory. The build steps for the `app` and the `server` take care of including the configs in the correct places. You can check those out in 

## Basic usage

Create the `app` directory and add your app code.

Create the `src` directory if building off from a vendors app code. (So you can leave that untouched in app).

Adjust `compose.yaml` and the build scripts, [`server.Dockerfile`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/server.Dockerfile) and [`app.Dockerfile`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/app.Dockerfile) as needed.

MariaDB builds from the latest image, but relies on a local `.env` file for its final environment definitions. So, you'll need to add this `.env` file and your defintions to the projects root, like:

```
MARIADB_ROOT_PASSWORD=
MARIADB_DATABASE=
MARIADB_USER=
MARIADB_PASSWORD=
```

Once thats all done, run `docker compose up` from the projects root and your project should come alive ⚡️

Go to your [apps configured server name](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/config/nginx.app.conf#L7) in browser and see if it works 🤓

## Check out the CLI framework 😄
Typing the same few commands over and over? Check out the included [CLI](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/tree/main/utils/cli) framework and throw in your most used commands.  