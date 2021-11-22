#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/config.sh

# ジョブ投入関数
# Reference：https://docs.aws.amazon.com/cli/latest/reference/batch/submit-job.html
#
# args1 : 投入するジョブの名前
# args2 : 環境変数パラメーター１
# args3 : 環境変数パラメーター２ 
function submit_job () {
	NAME="${1}"	
	PARAM1="${2}"
	PARAM2="${3}"

	# オプション：環境変数パラメーターを渡す
	OPTION="{"
		OPTION="${OPTION}\"environment\":["
			OPTION="${OPTION}{"
				OPTION="${OPTION}\"name\":\"PARAM1\","
				OPTION="${OPTION}\"value\":\"${PARAM1}\""
			OPTION="${OPTION}},"
			OPTION="${OPTION}{"
				OPTION="${OPTION}\"name\":\"PARAM2\","
				OPTION="${OPTION}\"value\":\"${PARAM2}\""
			OPTION="${OPTION}}"
		OPTION="${OPTION}]"
	OPTION="${OPTION}}"

	# ジョブ定義
	DEFINITION=${JOB_DEFINITION}
	if [ -n "${JOB_DEFINITION_VERSION}" ]; then
		DEFINITION="${DEFINITION}:${JOB_DEFINITION_VERSION}"
	fi

	aws batch submit-job \
	--job-name ${NAME} \
	--job-definition ${DEFINITION} \
	--job-queue ${JOB_QUEUE} \
	--container-overrides ${OPTION}
}