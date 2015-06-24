#! /bin/bash   
set -e

docker info

# build web image
docker build -t stsilabs/openfda-web:$CIRCLE_SHA1 .
    
# run docker containers
if [ "$BUILD_POSTGRES_IMAGE" = "true"  ]
then
  docker run --name openfda-postgres -e POSTGRES_USER=$POSTGRES_USER -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d postgres:9.4
  docker run --link openfda-postgres:postgres -p 80:80 -e "RAILS_ENV=demo" --name openfda-web stsilabs/openfda-web:$CIRCLE_SHA1 bundle exec rake db:setup
  # create image
  docker commit openfda-postgres stsilabs/openfda-postgres:$OPENFDA_POSTGRES_VERSION
  docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASSWORD
  docker push stsilabs/openfda-postgres:$OPENFDA_POSTGRES_VERSION
fi
