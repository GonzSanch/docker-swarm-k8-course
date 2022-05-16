#!/bin/bash

# This script was created for linux UNIX in other systems with docker engine
# any other OS with docker desktop as WIN or MACOS will not work as expected

# Also you con try this on https://labs.play-with-docker.com/

echo 'Generating certs..'
mkdir -p certs
openssl req -newkey rsa:4096 -nodes -sha256 \
    -keyout certs/domain.key -x509 -days 365 \
    -out certs/domain.crt

mkdir /etc/docker/certs.d
mkdir /etc/docker/certs.d/127.0.0.1:5000

pkill dockerd
dockerd > /dev/null 2>&1 &

echo 'Generate auth user..'
mkdir auth
docker run --entrypoint htpasswd registry:latest -Bbn admin admin > auth/htpasswd

echo 'Running registry..'
mkdir registry-data
docker run -d -p 5000:5000 --name registry \
    --restart unless-stopped \
    -v $(pwd)/registry-data:/var/lib/registry \
    -v $(pwd)/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
    -e REGISTRY_AUTH=htpasswd \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
    registry

# For testing purpouse you can use hello-world image making a tag for
# 127.0.0.1:5000/hello-world and remember to login with docker login 127.0.0.1:5000
# before push or pull any image on registry