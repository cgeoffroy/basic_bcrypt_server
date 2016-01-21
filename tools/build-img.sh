#! /bin/bash -e

docker build -f 'tools/Dev.Dockerfile' --build-arg=USER_ID="$(id -u)" --build-arg=USER_GROUP="$(id -g)" -t 'basic_bcrypt_server' .
