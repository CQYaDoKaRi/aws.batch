#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ---------------------------------
# 環境変数
# ---------------------------------
# リージョン
AWS_REGION="ap-northeast-1"

# S3バケット名
AWS_BATCH_BACKET=""

# ECR - アカウントID
AWS_ECR_AID=""
# ECR - レポジトリ名
AWS_ECR_REP=""

# ---------------------------------
# config.sh 内のプログラムの設定
# ---------------------------------
# データ - 拡張子
DATA_EXT=".dat"

# データ - ローカルフォルダー（S3 アップロードデータ=インプットデータ）
DATA_DIR_SRC="${DIR}/data.src"
# データ - ローカルフォルダー
DATA_DIR="${DIR}/data"
# データ - ローカルファイル
DATA_FILE="data.tar.gz"
# データ - S3バケット：フォルダー名
DATA_BACKET_PATH="/data/"

# 結果 - ローカルフォルダー
OUT_DIR="${DIR}/out"
# 結果 - ローカルファイル（圧縮）
OUT_FILE="out.tar.gz"
# 結果 - S3バケット：フォルダー名
OUT_BACKET_PATH="/out/"

# コンテナ - イメージタグ名(docker-compose.yml のimageに合わせる)
DOCKER_IMAGE_TAG="aws_batch:dev"

# ---------------------------------
# config.sh を上書きする外部ファイル
# ※省略可
# ---------------------------------
if [ -e "${DIR}/config.env.sh" ]; then
	source ${DIR}/config.env.sh
fi

# ---------------------------------
# 環境変数：AWS BATCH
# 設定されている場合は上書きする
# ---------------------------------
if [ ! -z "${CONFIG_AWS_REGION}" ]; then
	# リージョン
	AWS_REGION=${CONFIG_AWS_REGION}
	echo "[config.sh - set by AWS Batch] region:${AWS_REGION}"
fi

if [ ! -z "${CONFIG_AWS_BACKET}" ]; then
	# S3バケット名
	AWS_BATCH_BACKET=${CONFIG_AWS_BACKET}
	echo "[config.sh - set by AWS Batch] S3 backet:${AWS_BATCH_BACKET}"
fi

if [ ! -z "${CONFIG_AWS_ECR_AID}" ]; then
	# ECR - アカウントID
	AWS_ECR_AID=${CONFIG_AWS_ECR_AID}
	echo "[config.sh - set by AWS Batch] ECR AcountID:${AWS_ECR_AID}"
fi

if [ ! -z "${CONFIG_AWS_ECR_REP}" ]; then
	# ECR - レポジトリ名
	AWS_ECR_REP=${CONFIG_AWS_ECR_REP}
	echo "[config.sh - set by AWS Batch] ECR Repository:${AWS_ECR_REP}"
fi

# ---------------------------------
# config.sh 内のプログラムの設定
# - バケット
# ---------------------------------
# データ - S3バケット
DATA_BACKET="${AWS_BATCH_BACKET}${DATA_BACKET_PATH}"
# 結果 - S3バケット
OUT_BACKET="${AWS_BATCH_BACKET}${OUT_BACKET_PATH}"