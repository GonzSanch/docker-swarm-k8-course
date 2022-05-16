#!/bin/bash

echo "psqlpass" | docker secret create psql-pw -
docker stack deploy -c docker-compose.yml drupal