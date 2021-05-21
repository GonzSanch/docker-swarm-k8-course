#!/bin/bash
echo 'ubuntu'
docker container run -it --rm ubuntu:14.04 apt-get install curl && curl --version

echo 'Centos'
docker container run -it --rm centos:7 curl --version 