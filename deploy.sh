#! /bin/bash

POSTGRES_PASSWORD=$1
DOCKERRUN_FILE=Dockerrun.aws.json

# Deploy image to Docker Hub
docker push cjcassatt/openfda:$SHA1

# Create new Elastic Beanstalk version
EB_BUCKET=open-fda

# variable substitutions
sed "s/<POSTGRES_PASSWORD>/$POSTGRES_PASSWORD/" < $DOCKERRUN_FILE.template > $DOCKERRUN_FILE

# elastic beanstalk requires application source to be zipped
zip $DOCKERRUN_FILE.zip $DOCKERRUN_FILE

aws s3 cp $DOCKERRUN_FILE s3:.zip//$EB_BUCKET/$DOCKERRUN_FILE.zip
aws elasticbeanstalk create-application-version --application-name open-fda-stsi \
  --version-label $SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE.zip \
  --region us-east-1

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name open-fda-stsi \
    --version-label $SHA1 --region us-east-1