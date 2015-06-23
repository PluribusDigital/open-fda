#! /bin/bash   
SHA1=$1
POSTGRES_USER=$2
POSTGRES_PASSWORD=$3
BUILD_POSTGRES_IMAGE=$4

docker info

# build web image
docker build -t stsilabs/openfda-web:$CIRCLE_SHA1 .
    
# run docker containers
docker run --name openfda-postgres -e POSTGRES_USER=$POSTGRES_USER -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d postgres:9.4
docker run --link openfda-postgres:postgres -p 80:80 -e "RAILS_ENV=demo" --name openfda-web stsilabs/openfda-web:$SHA1 bundle exec rake db:setup
 
#build postgres image   
if [ "$BUILD_POSTGRES_IMAGE" = "true"  ]; then docker commit postgres stsilabs/openfda-postgres; fi