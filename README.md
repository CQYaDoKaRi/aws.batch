# AWS.Batch

## 構成
- IAM  
	S3 にアクセスするため、IAM ポリシーとロールを作成  

	- IAM ポリシーの作成  
		ポリシー名：`batch-policy`
		```
		{
			"Version": "2012-10-17",
			"Statement": [
				{
					"Sid": "aws-batch",
					"Effect": "Allow",
					"Action": "s3:*",
					"Resource": "arn:aws:s3:::{バケット名}/*"
				}
			]
		}
		```
		※利用する S3 の利用権限に絞った設定をする  
	
	- IAM ロールの作成  
		ロール名：`batch-role`
		- 信頼されたエンティティの種類を選択  
			- AWS サービス  
				- Elastic Container Service  
					- Elastic Container Service Task  
		- Attach アクセス権限ポリシー  
			- [AmazonECSTaskExecutionRolePolicy]をアタッチ 
			- [`batch-policy`]をアタッチ 

- S3 バケット
	data と out フォルダーを作成する
	- data  
		[init.sh]により処理に必要なインプットデータを配置
	- out  
		処理スクリプト[run.sh]により処理結果が保存される

## プログラム
- config.sh  
	init.sh, run.sh, docker_exec*.sh, job.sh の共通の設定ファイル  
	- 単体で実行、もしくは、固定値で実行する場合  
		```
		# リージョン
		AWS_REGION="ap-northeast-1"
		# S3バケット名
		AWS_BATCH_BACKET="S3のバケット名" 
		#  ECR - アカウントID
		AWS_ECR_AID="ECRのアカウントID"
		# ECR - レポジトリ名
		AWS_ECR_REP="ECRのレポジトリ名"

		# ジョブ定義
		JOB_DEFINITION="AWS Batch のジョブ定義名"
		# ジョブ定義：バージョン(バージョンがない場合、省略可)
		JOB_DEFINITION_VERSION="AWS Batch のジョブ定義のバージョン"
		# ジョブキュー
		JOB_QUEUE="AWS Batch のジョブキュー名"
		```
	- AWS Batch の環境変数で設定する場合  
		以下を設定すると、上記の設定を上書きしてスクリプトが動作する  
		`マネージメントコンソール > AWS Batch > ジョブ定義 > コンテナのプロパティ > 環境変数` 
		|名前|値|
		|---|---|
		|CONFIG_AWS_REGION|ap-northeast-1|
		|CONFIG_AWS_BACKET|S3のバケット名|
		|CONFIG_AWS_ECR_AID|ECRのアカウントID|
		|CONFIG_AWS_ECR_REP|ECRのレポジトリ名|

- init.sh  
	`./data.src/*.dat` を圧縮し、S3バケットの[data]フォルダーへデータをアップロード  

- run.sh  
	処理スクリプト  
	※コンテナ内で実行する  
	１．S3バケットの[data]フォルダーから処理に必要なインプットデータを取得  
	２．１のデータを解凍する  
	３．２のデータ内にあるすべてのファイルを結合して１ファイルにまとめて出力  
	４．３のデータを圧縮する  
	５．４のデータをS3バケットの[out]フォルダーへ保存する  
	６．このスクリプトで生成した中間データを削除する  

- install.sh  
	コンテナ内に必要なコマンド類のインストールスクリプト  
	※コンテナ内で実行する  

- docker_build.sh  
	docker-compose により、コンテナを作成後、起動  
	（既にコンテナが起動している場合は、停止してから作成）

- docker_build_exec_run.sh  
	docker-compose により、コンテナを作成後、起動、コンテナ内の[run.sh]を実行  
	（既にコンテナが起動している場合は、停止してから作成）

- docker_clean.sh  
	docker-compose により、コンテナを停止して、イメージを削除  

- docker_exec_run.sh  
	コンテナ内の[run.sh]を実行  
	※コンテナが起動している必要あり  

- docker_exec.sh  
	コンテナ内にログイン  
	※コンテナが起動している必要あり  

- ecr.sh  
	AWS Elastic Container Registry (ECR) へコンテナイメージを登録する
	- レジストリ用の Docker login 認証コマンド文字列を取得  
		12時間有効な認証トークンが発行  
		```
		aws ecr get-login-password | docker login --username AWS --password-stdin {アカウントID}.dkr.ecr.{リージョン}.amazonaws.com
		```
		
	- ECR へ登録する前にタグ付け
		```
		docker tag aws_batch:dev {アカウントID}.dkr.ecr.{リージョン}.amazonaws.com/{レポジトリ}
		```
	- ECR へ登録
		```
		docker push {アカウントID}.dkr.ecr.{リージョン}.amazonaws.com/{レポジトリ}
		```
	- ECR へ登録したイメージ削除
		```
		docker rmi {アカウントID}.dkr.ecr.{リージョン}.amazonaws.com/{レポジトリ}
		```
## プログラムの利用方法
- １．コンテナに含める前に動作確認する
	- １－１．init.sh  
		S3へデータをアップロード  
	- １－２．run.sh  
		S3へ処理結果がアップロードされる  
  
- ２．コンテナを作成して動作確認する  
	- docker_build_exec_run.sh  
		コンテナ作成、起動後、コンテナ内の[run.sh]が実行される  
		S3へ処理結果がアップロードされる  
  
- ３．AWS Elastic Container Registry (ECR) へコンテナイメージを登録  
	- ecr.sh  

- ４．AWS Batch を設定  
  
- ５．AWS CLI でJOB投入  
	- job.sh {投入回数} 
		+ job_common.sh  
  
## AWS Batch を設定する
- １．[コンピューティング環境]を作成  
- ２．[ジョブキュー]を作成  
- ３．[ジョブ定義]を作成  
- ４．[ジョブ]を作成して実行  

AWS Batch の設定ポイント  

- AWS Batch  
	- ジョブ定義  
		- ジョブ定義の作成  
			- コンテナプロパティ  
				- 実行ロール  
					[`batch-policy`]を選択  
	- パブリック IP を割り当て  
		- ☑ 有効化  
			※ublic subnet に設置する場合  
	- その他の設定  
		- ジョブロール  
			[`batch-policy`]を選択  

## ログ
- CloudWatch
	- ロググループ[/aws/batch/job]のログを確認

