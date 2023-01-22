# 👋 welcome to your docker nginx mariadb php-fpm app
This is a framework for a local [Docker](https://www.docker.com/) web app that uses [Omeka S](https://omeka.org/s/) as an application base with [NGINX](https://www.nginx.com/), [PHP-FPM](https://php-fpm.org/), and [MariaDB](https://mariadb.org/) powering the frontend and backend networks. 
​
## General app framework and container paths

```
db  / :/var/lib/mysql
app / :/usr/share/nginx/app
src / 
    --- themes  / :/usr/share/nginx/app/themes
    --- modules / :/usr/share/nginx/app/modules
    --- files   / :/usr/share/nginx/app/files
config /
    --- nginx.app.conf:/etc/nginx/conf.d/app.conf
    --- php-fpm.conf:/usr/local/etc/php-fpm.d/app.conf
utils /
    --- server.Dockerfile
    --- app.Dockerfile
    --- cli /
```
​
The `app` and `src` directories are dependendent on your web app of choice. For this example, I used [Omeka S](https://github.com/omeka/omeka-s/releases/tag/v4.0.0). Since Omeka S has a `/files` directory thats shared accross the PHP worker and the web server, I created a shared volume for this directory. 

Configs are also found in their own local [`configs`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/tree/main/config) directory. These are then mounted in the appropriate place using the `config` directive in [`compose.yaml`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/compose.yaml).

## Basic usage

Add your app code to the `app` directory. I've set `git` to ignore everything in the `app` directory except the `.gitignore` file itself. Remove or adjust the directory's `.gitignore` file as needed.

Create the `src` directory if building off from a vendors app code. The `src` directory can then hold things unique to your app, like `/files`, `/themes`, and `/modules` in my Omeka S example. Then we can aggregate our sources during the build step. 

Adjust [`compose.yaml`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/compose.yaml) and the build scripts, [`server.Dockerfile`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/server.Dockerfile) and [`app.Dockerfile`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/app.Dockerfile) as needed.

MariaDB builds from the latest image, but relies on a local `.env` file for its environment definitions. So, create this `.env` file in your projects root and add your defintions, like:

```
MARIADB_ROOT_PASSWORD='rootpassword'
MARIADB_DATABASE='app'
MARIADB_USER='appuser'
MARIADB_PASSWORD='appuserpassword'
```

Once thats all done, run `docker compose up` from the projects root and your project should come alive ⚡️

Go to your [apps configured server name](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/config/nginx.app.conf#L7) in browser and see if it works 🤓

## Check out the CLI framework 😄
Typing the same few commands over and over? Check out the included [CLI](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/tree/main/utils/cli) framework and throw in your most used [commands]().  