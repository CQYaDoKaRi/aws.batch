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
	init.sh, run.sh の共通の設定ファイル  

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

## VPCエンドポイント（PrivateLink）を利用する場合  
`TODO`  

## ログ
- CloudWatch
	- ロググループ[/aws/batch/job]のログを確認

