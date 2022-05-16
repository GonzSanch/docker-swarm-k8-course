#!/bin/bash

if [[ $1 == "start" ]]; then
    docker container run -p 80:80 -d --name webhost nginx
    docker container run -p 8080:80 -d --name apache httpd
    docker container run -p 3306:3306 -d --name db -e MYSQL_RANDOM_ROOT_PASSWORD=yes mysql
elif [[ $1 == "close" ]]; then
    docker container stop webhost apache db
    docker container rm webhost apache db
    docker container ls
elif [[ $1 == "logs" ]]; then
    docker container logs db
else
    echo "bad usage: ./setup.sh start/close/logs"
fi