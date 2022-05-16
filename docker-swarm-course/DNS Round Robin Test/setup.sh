#!/bin/bash
echo 'Create network:'
docker network create robin

echo 'Run 2 containers with net-alias of elasticsearch:2'
docker container run -d --net robin --net-alias search elasticsearch:2
docker container run -d --net robin --net-alias search elasticsearch:2
docker container ls

echo 'Run OS test'
docker run --rm --net robin alpine nslookup search
docker run --rm --net robin centos curl -s search:9200
docker run --rm --net robin centos curl -s search:9200
docker run --rm --net robin centos curl -s search:9200
docker run --rm --net robin centos curl -s search:9200
