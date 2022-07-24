#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/job_common.sh

# ジョブ名
function dt() {
	echo "${1}`date +%Y%m%d'%T' | tr -d :`"
}

# ジョブ投入
# 投入回数
MAX=1
if [[ "${1}" =~ ^[0-9]+$ ]]; then
	MAX=${1}
fi

for i in `seq 1 ${MAX} `;
do
	# 環境変数の引数1
	PARAM1="${i}"
	# 環境変数の引数2
	PARAM2=$((${i}*10))

	# submit_job "{ジョブ投入名}" "{環境変数の引数１}" "{環境変数の引数２}"
	submit_job `dt "job-"` "${PARAM1}" "${PARAM2}"
done;