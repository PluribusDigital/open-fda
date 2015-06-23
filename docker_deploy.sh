#! /bin/bash

SHA1=$1
POSTGRES_PASSWORD=$2
DOCKERRUN_FILE=Dockerrun.aws.json

# Deploy image to Docker Hub
docker push cjcassatt/openfda:$SHA1

docker commit postgres stsilabs/openfda-postgres
docker push stsilabs/openfda-postgres

# Create new Elastic Beanstalk version
EB_BUCKET=open-fda

# variable substitutions
sed "s/<TAG>/$SHA1/" < $DOCKERRUN_FILE.template > $DOCKERRUN_FILE

# elastic beanstalk requires application source to be zipped
zip $DOCKERRUN_FILE.zip $DOCKERRUN_FILE

aws s3 cp $DOCKERRUN_FILE.zip s3://$EB_BUCKET/$DOCKERRUN_FILE.zip
aws elasticbeanstalk create-application-version --application-name open-fda-stsi \
  --version-label $SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE.zip \
  --region us-east-1

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name open-fda-stsi \
    --version-label $SHA1 --region us-east-1