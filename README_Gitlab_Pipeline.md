# PetClinicをGitlabのPipelineで動かして、脆弱性検査もする手順

### 前提条件
- 既にGitlab, Gitlab Runnerの環境は構築済みであること。
- Gitlabにブランクのプロジェクトを作成しておいてください。

### 準備
このプロジェクトのリポジトリをそのままGitlabのブランクプロジェクトに切り替えます。


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
