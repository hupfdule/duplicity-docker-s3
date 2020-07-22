#!/bin/sh

if [ "$#" = 0 ]; then
  version=latest
else
  version="$1"
fi

docker build -t duplicity-docker-s3:${version} .
