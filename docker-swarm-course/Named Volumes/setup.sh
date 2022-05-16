#!/bin/bash

echo 'create psql with volume'
docker run -d --name psql -v psql:/var/lib/postgresql/data postgres:9.6.1
docker container ls
docker volume ls

echo 'logs:'
docker container logs psql

echo 'stop and erase container psql'
docker container stop psql
docker container ls

echo 'create new psql container with exist volume'
docker run -d --name psql2 -v psql:/var/lib/postgresql/data postgres:9.6.2
docker container ls -a
docker volume ls
docker container logs psql2