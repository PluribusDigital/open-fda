#! /bin/bash
set -e

DOCKERRUN_FILE=Dockerrun.aws.json

# Deploy web image to Docker Hub
docker push stsilabs/openfda-web:$CIRCLE_SHA1

# Deploy postgres image to Docker Hub
#if [ "$BUILD_POSTGRES_IMAGE" = "true"  ]
#then
#  docker push stsilabs/openfda-postgres:$OPENFDA_POSTGRES_VERSION
#fi

# Create new Elastic Beanstalk version
EB_BUCKET=open-fda

# variable substitutions
sed -e "s/<TAG>/$CIRCLE_SHA1/" \
    -e "s/<POSTGRES_USER>/$POSTGRES_USER/" \
    -e "s/<OPENFDA_POSTGRES_VERSION>/$OPENFDA_POSTGRES_VERSION/" \
    -e "s/<POSTGRES_PASSWORD>/$POSTGRES_PASSWORD/" \
    -e "s/<OPENFDA_API_KEY>/$OPENFDA_API_KEY/" \
    < $DOCKERRUN_FILE.template > $DOCKERRUN_FILE

# elastic beanstalk requires application source to be zipped
zip $DOCKERRUN_FILE.zip $DOCKERRUN_FILE

aws s3 cp $DOCKERRUN_FILE.zip s3://$EB_BUCKET/$DOCKERRUN_FILE.zip
aws elasticbeanstalk create-application-version --application-name open-fda-stsi \
  --version-label $CIRCLE_SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE.zip \
  --region us-east-1

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name open-fda-stsi \
    --version-label $CIRCLE_SHA1 --region us-east-1
