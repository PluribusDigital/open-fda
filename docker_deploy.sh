#! /bin/bash
set -e

DOCKERRUN_FILE=Dockerrun.aws.json

# Deploy web image to Docker Hub
docker push stsilabs/openfda-web:$CIRCLE_BUILD_NUM

if [ "$DOCKER_IMAGE_LATEST" = "true"  ]
then
  # Tag as latest and push again
  docker tag stsilabs/openfda-web:$CIRCLE_BUILD_NUM stsilabs/openfda-web:latest
  docker push stsilabs/openfda-web:latest
fi

if [ "$SEED_DB" = "true"  ]
then
  DB_INIT_COMMAND = "bundle exec rake db:setup"
else
  DB_INIT_COMMAND = "bundle exec rake db:migrate"
fi

# Create new Elastic Beanstalk version
EB_BUCKET=open-fda

cd deploy/beanstalk
# variable substitutions
sed -e "s/<TAG>/$CIRCLE_BUILD_NUM/" \
    -e "s/<POSTGRES_USER>/$POSTGRES_USER/" \
    -e "s/<OPENFDA_POSTGRES_VERSION>/$OPENFDA_POSTGRES_VERSION/" \
    -e "s/<POSTGRES_PASSWORD>/$POSTGRES_PASSWORD/" \
    -e "s/<OPENFDA_API_KEY>/$OPENFDA_API_KEY/" \
    -e "s/<NEW_RELIC_KEY>/$NEW_RELIC_KEY/" \
    -e "s/<DB_INIT_COMMAND>/$DB_INIT_COMMAND/"
    < $DOCKERRUN_FILE.template > $DOCKERRUN_FILE

# elastic beanstalk requires application source to be zipped
zip -r $DOCKERRUN_FILE.zip $DOCKERRUN_FILE .ebextensions

aws s3 cp $DOCKERRUN_FILE.zip s3://$EB_BUCKET/$DOCKERRUN_FILE.zip
aws elasticbeanstalk create-application-version --application-name open-fda-stsi \
  --version-label $CIRCLE_BUILD_NUM --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE.zip \
  --region us-east-1

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name open-fda-stsi \
    --version-label $CIRCLE_BUILD_NUM --region us-east-1
	
cd ../..
