#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ---------------------------------
# 環境変数
# ---------------------------------
# 動作確認用のアプリケーションバージョン
# ・関連するプログラム
#   - run.sh
VERSION="1.0"

# リージョン
# ・関連するプログラム
#   - ecr.sh
AWS_REGION="ap-northeast-1"

# ECR - アカウントID
# ・関連するプログラム
#   - ecr.sh
AWS_ECR_AID=""
# ・関連するプログラム
#   - ecr.sh
# ECR - レポジトリ名
AWS_ECR_REP=""

# S3バケット名
# ・関連するプログラム
#   - run.sh
AWS_BATCH_BACKET=""

# ---------------------------------
# config.sh 内のプログラムの設定
# ---------------------------------
# データ - 拡張子
# ・関連するプログラム
#   - run.sh
DATA_EXT=".dat"

# データ - ローカルフォルダー（S3 アップロードデータ=インプットデータ）
# ・関連するプログラム
#   - run.sh
DATA_DIR_SRC="${DIR}/data.src"
# データ - ローカルフォルダー
# ・関連するプログラム
#   - run.sh
DATA_DIR="${DIR}/data"
# データ - ローカルファイル
# ・関連するプログラム
#   - run.sh
DATA_FILE="data.tar.gz"
# データ - S3バケット：フォルダー名
# ・関連するプログラム
#   - run.sh
DATA_BACKET_PATH="/data/"

# 結果 - ローカルフォルダー
# ・関連するプログラム
#   - run.sh
OUT_DIR="${DIR}/out"
# 結果 - ローカルファイル（圧縮）
# ・関連するプログラム
#   - run.sh
OUT_FILE="out.tar.gz"
# 結果 - S3バケット：フォルダー名
# ・関連するプログラム
#   - run.sh
OUT_BACKET_PATH="/out/"

# コンテナ - イメージタグ名(docker-compose.yml のimageに合わせる)
# ・関連するプログラム
#   - ecr.sh
DOCKER_IMAGE_TAG="aws_batch:dev"

# コンテナ - コンテナ名(docker-compose.yml のcontainer_nameに合わせる)
# ・関連するプログラム
#   - docker_exec.sh
#   - docker_exec_run.sh
DOCKER_CONTAINER_NAME="aws_batch_dev"

# ジョブ定義
# ・関連するプログラム
#   - job_common.sh
JOB_DEFINITION=""
# ジョブ定義：バージョン(バージョンがない場合、省略可)
# ・関連するプログラム
#   - job_common.sh
JOB_DEFINITION_VERSION=""
# ジョブキュー
# ・関連するプログラム
#   - job_common.sh
JOB_QUEUE=""

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
# ・関連するプログラム
#   - run.sh
DATA_BACKET="${AWS_BATCH_BACKET}${DATA_BACKET_PATH}"
# 結果 - S3バケット
# ・関連するプログラム
#   - run.sh
OUT_BACKET="${AWS_BATCH_BACKET}${OUT_BACKET_PATH}"