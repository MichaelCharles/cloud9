## [Click here to go to Docker Hub.](https://cloud.docker.com/u/mcaubrey/repository/docker/mcaubrey/cloud9)

# Cloud9 in a Docker Container

This is a recently built (2019) instance of Cloud9 running inside a Docker container. The `latest` tag does not come with additional packages installed and is ideal for connecting with any other container, while other tags specify what sort of additional packages are installed along with Cloud9.

The following is an example `docker-compose.yml` file for running Cloud9 connected to another container. In this example, your project files would actually be served by the container using the `php:7.2-apache` image, but you would edit the files through the separate Cloud9 container.

```
version: '3'
services:
  app:
    image: php:7.2-apache
    container_name: 'app'
    ports:
      - 80:80
    volumes: ./workspace:/var/www/html:rw
  db:
    image: mariadb
    container_name: 'db'
    ports:
      - 3306:3306
    environment:
      MYSQL_USER: 'username'
      MYSQL_PASSWORD: 'secretp4ss'
      MYSQL_DATABASE: 'database'
      MYSQL_ROOT_PASSWORD: 'supersecretp4ss'
    volumes:
      - ./db-data:/var/lib/mysql:rw
  adminer:
    image: mcaubrey/adminer
    container_name: 'adminer'
    ports:
      - 8080:8080
    environment:
      ADMINER_DEFAULT_SYSTEM: "mysql"
      ADMINER_DEFAULT_SERVER: "db"
      ADMINER_DEFAULT_USERNAME: "username"
      ADMINER_DEFAULT_PASSWORD: "secretp4ss"
      ADMINER_DEFAULT_DATABASE: "database"
  c9:
    image: mcaubrey/cloud9
    container_name: c9
    volumes:
      - ./workspace:/var/www/html:rw
    ports:
      - 9000:8080
    environment:
      WORKSPACE: '/var/www/html'
```

The Cloud9 image with the `php7.2-apache` tag comes with PHP 7.2, Composer and Apache already installed and ready to go. Here is an example setup where the files are being served by the Cloud9 container.

```
version: '3'
services:
  db:
    image: mariadb
    container_name: 'db'
    ports:
      - 3306:3306
    environment:
      MYSQL_USER: 'username'
      MYSQL_PASSWORD: 'secretp4ss'
      MYSQL_DATABASE: 'database'
      MYSQL_ROOT_PASSWORD: 'supersecretp4ss'
    volumes:
      - ./db-data:/var/lib/mysql:rw
  adminer:
    image: mcaubrey/adminer
    container_name: 'adminer'
    ports:
      - 8080:8080
    environment:
      ADMINER_DEFAULT_SYSTEM: "mysql"
      ADMINER_DEFAULT_SERVER: "db"
      ADMINER_DEFAULT_USERNAME: "username"
      ADMINER_DEFAULT_PASSWORD: "secretp4ss"
      ADMINER_DEFAULT_DATABASE: "database"
  c9:
    image: mcaubrey/cloud9:php7.2-apache
    container_name: c9
    volumes:
      - ./workspace:/var/www/html:rw
    ports:
      - 80:80
      - 9000:8080
    environment:
      WORKSPACE: '/var/www/html'
```

# Environment Variables

This image comes with a few environment variables to help you customize your experience. By setting `$C9_USER` and `$C9_PASS`, you'll enable authorization making it so that users must present and username and password to access your workspace. You can specify the location of your workspace with the `C9_WORKSPACE` variable. This should generally match the location of your mounted volume. Last, there is a `$C9_EXTRA` variable for you to include anything else you want to run as an argument to Cloud9's `server.js` file. You'll most likely not need this, but it is there for you if you want it. 
