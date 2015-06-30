#! /bin/bash   
set -e

docker info

# build web image
docker build -t stsilabs/openfda-web:$CIRCLE_BUILD_NUM .

