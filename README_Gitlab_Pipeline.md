# PetClinicをGitlabのPipelineで動かして、脆弱性検査もする手順

### 前提条件
- 既にGitlab, Gitlab Runnerの環境は構築済みであること。
- Gitlabにブランクのプロジェクトを作成しておいてください。

### 準備
#### GitlabプロジェクトへのCICD用環境変数の設定
作成したプロジェクトの *Settings> CI/CD* を開きます。  
Variablesに以下の変数と値を設定します。**環境に合わせて適宜変更してください。**
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

#### PetClinicDemoの配置
このプロジェクトのリポジトリをそのままGitlabのブランクプロジェクトに切り替えます。
```bash
git remote rename origin old-origin
git remote add origin http://localhost:8080/root/petclinic.git # これはGitlabに作ったプロジェクトのclone URLに合わせてください。
git push -u origin --all
```
Gitlabに既に作成済みのプロジェクトにファイルが格納されていることを確認してください。  
Push後、すぐにパイプラインが動きます。

#### その他
- パイプラインの処理の変更については、```.gitlab-ci.yml```を弄ってください。
- petclinic-testステージで使っているubuntu:20.04はjdk1.8, python3などが入ったDockerイメージを作って利用したほうが効率的ですが、ここでは割愛しています。
