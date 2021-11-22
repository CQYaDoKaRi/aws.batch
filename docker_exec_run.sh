#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/config.sh

if [ -e ${DIR}/config.env.sh ]; then
    echo "[config.sh] copy ${DOCKER_CONTAINER_NAME}:/usr/local/aws.batch/config.env.sh"
    docker cp ${DIR}/config.env.sh ${DOCKER_CONTAINER_NAME}:/usr/local/aws.batch/config.env.sh
fi
docker exec -it ${DOCKER_CONTAINER_NAME} /usr/local/aws.batch/run.sh