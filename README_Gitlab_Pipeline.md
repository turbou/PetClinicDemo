# PetClinicをGitlabのPipelineで動かして、脆弱性検査もする手順

### 前提条件
- 既にGitlab, Gitlab Runnerの環境は構築済みであること。
- Gitlabにブランクのプロジェクトを作成しておいてください。

### 準備
#### GitlabプロジェクトへのCICD用環境変数の設定
作成したプロジェクトの *Settings> CI/CD* を開きます。  
Variablesに以下の変数と値を設定します。*環境に合わせて適宜変更してください。*  
***Protect Variableのチェックボックスのチェックは外してください。***
- AGENT_VERSION  
  5.2.2
- CONTRAST_URL  
  https://eval.contrastsecurity.com/Contrast
- ORG_ID  
- API_KEY  
- USER_NAME  
- SERVICE_KEY  
- AUTH_HEADER  
- APP_NAME  
  PetClinic_8001_GitlabDemo
- ENVIRONMENT  
  development
- SERVER_NAME  
  GitlabDemo

#### プロキシへの対応について
プロキシを経由させる場合は以下の対応を行ってください。  
##### .gitlab-ci.ymlの修正
プロキシに関する設定が各ステージでコメントアウトされているので、ホストとポートについては適切な値に変更のうえ  
コメントを外して有効化してください。  
認証プロキシでない場合は、PROXY_USER, PROXY_PASSのところはコメントアウトのまま、または除外してください。
##### CICD変数の追加（認証プロキシの場合）
- PROXY_USER  
- PROXY_PASS
必要に応じて「マスク」のチェックも入れてください。

#### PetClinic稼働用のDockerイメージビルド
```bash
docker build -t petclinic:1.0.0 -f Dockerfile_Gitlab_Pipeline .
```

#### PetClinicDemoの配置
このプロジェクトの参照先リモートリポジトリをそのままGitlabの作成済みブランクプロジェクトに切り替えます。
```bash
git remote rename origin old-origin
git remote add origin http://localhost:8080/XXXX/YYYYYYYY.git # これはGitlabに作ったプロジェクトのclone URLに合わせてください。
git push -u origin --all
```
Gitlabに既に作成済みのプロジェクトにファイルが格納されていることを確認してください。  
Push後、すぐにパイプラインが動きます。

#### その他
- パイプラインの処理の変更については、```.gitlab-ci.yml```を弄ってください。

