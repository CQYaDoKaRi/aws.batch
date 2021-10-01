#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/config.sh

aws ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ECR_AID}.dkr.ecr.${AWS_REGION}.amazonaws.com
docker tag ${DOCKER_IMAGE_TAG} ${AWS_ECR_AID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${AWS_ECR_REP}
docker push ${AWS_ECR_AID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${AWS_ECR_REP}
docker rmi ${AWS_ECR_AID}.dkr.ecr.ap-northeast-1.amazonaws.com/${AWS_ECR_REP}