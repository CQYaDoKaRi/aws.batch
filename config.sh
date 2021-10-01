#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ---------------------------------
# 環境変数として AWS Batch 側で設定
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
# データ - S3バケット
DATA_BACKET="${AWS_BATCH_BACKET}/data/"

# 結果 - ローカルフォルダー
OUT_DIR="${DIR}/out"
# 結果 - ローカルファイル（圧縮）
OUT_FILE="out.tar.gz"
# 結果 - S3バケット
OUT_BACKET="${AWS_BATCH_BACKET}/out/"

# コンテナ - イメージタグ名(docker-compose.yml のimageに合わせる)
DOCKER_IMAGE_TAG="aws_batch:dev"

if [ -e "${DIR}/config.env.sh" ]; then
	source ${DIR}/config.env.sh
fi
