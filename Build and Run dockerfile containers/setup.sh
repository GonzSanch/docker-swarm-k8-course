#!/bin/bash

echo 'build dockerfile'
docker build -t node-app .

echo 'run container locally'
docker run -p 80:3000 node-app

echo 'tag with registry org repository'
docker tag node-app:latest gonzsanch/node-example:latest

echo 'push to registry'
docker push gonzsanch/node-example:latest