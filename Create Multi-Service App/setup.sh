#!/bin/bash

echo 'Remember Run this script in your Swarm. I.e using docker-machine for multiple nodes on local'

echo 'Create network...'
docker network create -d overlay frontend
docker network create -d overlay backend

echo 'Create services...'
docker service create --name voting-app --network frontend --replicas 2 -p 80:80 bretfisher/examplevotingapp_vote
docker service create --name redis --network frontend redis:3.2
docker service create --name worker --network backend --network frontend bretfisher/examplevotingapp_worker:java
docker service create --name db --network backend --mount type=volume,source=db-data,target=/var/lib/postgresql/data -e POSTGRES_HOST_AUTH_METHOD=trust postgres:9.4
docker service create --name result --network backend -p 3000:80 bretfisher/examplevotingapp_result