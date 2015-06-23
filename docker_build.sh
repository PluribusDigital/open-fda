#! /bin/bash   
set -e

SHA1=$CIRCLE_SHA1

docker info

# build web image
docker build -t stsilabs/openfda-web:$SHA1 .
    
# run docker containers
docker run --name openfda-postgres -e POSTGRES_USER=$POSTGRES_USER -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d postgres:9.4
docker run --link openfda-postgres:postgres -p 80:80 -e "RAILS_ENV=demo" --name openfda-web stsilabs/openfda-web:$SHA1 bundle exec rake db:setup
 
# create image
docker commit openfda-postgres stsilabs/openfda-postgres

# push to hub
docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASSWORD
docker push stsilabs/openfda-postgres
