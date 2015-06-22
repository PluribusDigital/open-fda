#! /bin/bash

SHA1=$1
DEPLOY_ENVIRONMENT=$2
POSTGRES_PASSWORD=$3
$DOCKERRUN_FILE=Dockerrun.aws.json

# Deploy image to Docker Hub (always tag with "latest")
docker push cjcassatt/openfda:$SHA1

# Create new Elastic Beanstalk version
EB_BUCKET=open-fda

# variable substitutions
sed "s/<TAG>/$SHA1/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE
sed "s/<DEPLOY_ENVIRONMENT>/$DEPLOY_ENVIRONMENT/" < $DOCKERRUN_FILE > $DOCKERRUN_FILE
sed "s/<POSTGRES_PASSWORD>/$POSTGRES_PASSWORD/" < $DOCKERRUN_FILE > $DOCKERRUN_FILE

aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE
aws elasticbeanstalk create-application-version --application-name open-fda-demo \
  --version-label $SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE \
  --region us-east-1

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name open-fda-demo \
    --version-label $SHA1 --region us-east-1