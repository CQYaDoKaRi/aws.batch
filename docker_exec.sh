#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/config.sh

docker exec -it ${DOCKER_CONTAINER_NAME} /bin/bash