# Contrastエージェントオペレータデモ（Kubernetes編）

## 前提条件
Mac Docker Desktopで動作確認済み

## 前準備
### Kubernetesを有効化
docker desktopの設定画面でKubernetesを有効化しておいてください。

## 手順
### エージェントオペレータのインストール
- インストール
参考URL: https://docs.contrastsecurity.jp/ja/install-agent-operator.html  
  ```bash
  # オペレータのインストール  
  kubectl apply -f https://github.com/Contrast-Security-OSS/agent-operator/releases/latest/download/install-prod.yaml
  # Readyになったら知らせるようにする（任意）
  kubectl -n contrast-agent-operator wait pod --for=condition=ready --selector=app.kubernetes.io/name=operator,app.kubernetes.io/part-of=contrast-agent-operator--timeout=30s
  ```
- エージェントオペレータの起動確認  
  ```bash
  kubectl -n contrast-agent-operator get pods
  ```
  STATUSがRunningになっていればOKです。

### エージェントオペレータの設定
参考URL: https://docs.contrastsecurity.jp/ja/agent-operator-walkthrough.html#%E6%89%8B%E9%A0%86-2-%E3%82%AA%E3%83%9A%E3%83%AC%E3%83%BC%E3%82%BF%E3%81%AE%E8%A8%AD%E5%AE%9A  
- Contrastサーバへの認証情報を設定
  ```bash
  # ==================================================== #
  # contrastUrlは接続するContrastサーバに合わせて変更してください。
  # ==================================================== #
  kubectl -n contrast-agent-operator \
        create secret generic default-agent-connection-secret \
        --from-literal=contrastUrl=https://eval.contrastsecurity.com/Contrast \
        --from-literal=apiKey=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
        --from-literal=serviceKey=XXXXXXXXXXXXXXXX \
        --from-literal=userName=XXXXX@contrastsecurity.com
  ```
- ClusterAgentConnectionの作成  
  ```bash
  kubectl apply -f - <<EOF
  apiVersion: agents.contrastsecurity.com/v1beta1
  kind: ClusterAgentConnection
  metadata:
    name: default-agent-connection
    namespace: contrast-agent-operator
  spec:
    template:
      spec:
        url:
          secretName: default-agent-connection-secret
          secretKey: contrastUrl
        apiKey:
          secretName: default-agent-connection-secret
          secretKey: apiKey
        serviceKey:
          secretName: default-agent-connection-secret
          secretKey: serviceKey
        userName:
          secretName: default-agent-connection-secret
          secretKey: userName
  EOF
  ```

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
