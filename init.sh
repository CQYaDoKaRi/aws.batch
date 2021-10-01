#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/config.sh

cd ${DATA_DIR_SRC}
tar zcvf ${DATA_FILE} *${DATA_EXT}
cd ${DIR}
aws s3 cp ${DATA_DIR_SRC}/${DATA_FILE} s3://${BACKET_DATA}
rm -f ${DATA_DIR_SRC}/${DATA_FILE}