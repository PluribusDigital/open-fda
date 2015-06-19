# deploy.sh
#! /bin/bash

#SHA1=$1

# Deploy image to Docker Hub
#docker push circleci/hello:$SHA1

# Create new Elastic Beanstalk version
#EB_BUCKET=stsi-sandbox
#DOCKERRUN_FILE=$SHA1-Dockerrun.aws.json
#sed "s/<TAG>/$SHA1/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE
#aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE
#aws elasticbeanstalk create-application-version --application-name open-fda-dempo \
#  --version-label $SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=eb-docker-nginx-proxy.zip

# Update Elastic Beanstalk environment to new version
#aws elasticbeanstalk update-environment --environment-name phpTestApp-stsi-env \
#    --version-label $SHA1