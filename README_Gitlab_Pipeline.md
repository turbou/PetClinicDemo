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
git remote add origin http://localhost:8080/root/petclinic.git
git push -u origin --all
```
Gitlabに既に作成済みのプロジェクトにファイルが格納されていることを確認してください。

### ビルド方法
(jar生成)
```
mvn clean package -DskipTests
```
(war生成)
```
mvn clean package -DskipTests -f ./pom_4war.xml
```

### 実行方法
SpringBoot
```
java -jar ./target/spring-petclinic-1.5.1.jar --server.port=8001
```
次のURLでアクセス: http://localhost:8001/

### Contrast付き実行方法
```
java -javaagent:/path/to/contrast.jar -Dcontrast.server.name=user05_svr -Dcontrast.agent.java.standalone_app_name=PetClinic_user05 -jar ./target/spring-petclinic-1.5.1.jar --server.port=8001
```
