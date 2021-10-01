#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/config.sh

# フォルダ作成
if [ ! -d ${DATA_DIR} ]; then
  echo "・処理用入力データフォルダー作成[${DATA_DIR}]"
	mkdir ${DATA_DIR}
fi
if [ ! -d ${OUT_DIR} ]; then
  echo "・処理用出力データフォルダー作成[${OUT_DIR}]"
	mkdir ${OUT_DIR}
fi

# データ取得
echo "・処理用入力データ取得[s3://${DATA_BACKET}${DATA_FILE}]"
aws s3 cp s3://${DATA_BACKET}${DATA_FILE} ${DATA_DIR}/
if [ -f "${DATA_DIR}/${DATA_FILE}" ]; then
  cd ${DATA_DIR}/
  echo "・処理用入力データの圧縮ファイルを解凍[${DATA_FILE}]"
  tar zxvf ${DATA_FILE}
  echo "・処理用入力データの圧縮ファイルを削除[${DATA_FILE}]"
  rm -f ${DATA_FILE}
  cd ${DIR}

  # 処理
  OUT=""
  for FILE in ${DATA_DIR}/*${DATA_EXT}; do
    echo "・処理中[${FILE}]"
    FILE_DATA=$(<${FILE})
    OUT="${OUT}${FILE}\n${FILE_DATA}\n"
  done

  DT=`date "+%Y%m%d%H%M%S"`
  OUT_NAME=${DT}${DATA_EXT}
  echo "・処理用出力データフォルダーへ結果ファイルを保存[${OUT_DIR}/${OUT_NAME}]"
  echo -e "${OUT}" > ${OUT_DIR}/${OUT_NAME}

  echo "・処理用出力データフォルダーの結果ファイルを圧縮[${OUT_DIR}/${OUT_FILE}]"
  cd ${OUT_DIR}
  tar zcvf ${OUT_FILE} *${DATA_EXT}
  cd ${DIR}
  echo "・処理結果を保存[s3://${OUT_BACKET}${DT}_${OUT_FILE}]"
  aws s3 cp ${OUT_DIR}/${OUT_FILE} s3://${OUT_BACKET}${DT}_${OUT_FILE}

  if [ -d ${DATA_DIR} ]; then
    echo "・処理用入力データフォルダー削除[${DATA_DIR}]"
    rm -Rf ${DATA_DIR}
  fi
  if [ -d ${OUT_DIR} ]; then
    echo "・処理用出力データフォルダー作成[${OUT_DIR}]"
    rm -Rf ${OUT_DIR}
  fi
fi