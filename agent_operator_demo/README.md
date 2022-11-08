# Contrastエージェントオペレータデモ（Kubernetes編）

## 前提条件
Mac Docker Desktopで動作確認済み

## 前準備
### Kubernetesを有効化
docker desktopの設定画面でKubernetesを有効化しておいてください。

## 大まかな流れ
1. Contrastエージェントオペレータのセットアップ  
  エージェントオペレータのインストールとセットアップまで
2. PetClinicのデプロイ  
  PetClinicのビルドからコンテナ化、そしてKubernetesへのデプロイ
3. PetClinicへのエージェントの組み込み  
  ContrastエージェントオペレータをPetClinicを接続します。
4. Contrastサーバのオンボード確認  
  オンボード確認と打鍵を行い脆弱性が検知されるまでを確認します。

## 1. Contrastエージェントオペレータのセットアップ
### エージェントオペレータのインストール
参考URL: https://docs.contrastsecurity.jp/ja/install-agent-operator.html  
- インストール  
  ```bash
  # オペレータのインストール  
  kubectl apply -f https://github.com/Contrast-Security-OSS/agent-operator/releases/latest/download/install-prod.yaml
  # Readyになったら知らせるようにする（任意）
  kubectl -n contrast-agent-operator wait pod --for=condition=ready --selector=app.kubernetes.io/name=operator,app.kubernetes.io/part-of=contrast-agent-operator --timeout=30s
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
  kubectl -n contrast-agent-operator \
        create secret generic default-agent-connection-secret \
        --from-literal=apiKey=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
        --from-literal=serviceKey=XXXXXXXXXXXXXXXX \
        --from-literal=userName=XXXXX@contrastsecurity.com
  ```
- ClusterAgentConnectionの作成  
  **spec.template.spec.urlの値は接続するContrastサーバに応じて変更してください。**
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
        url: https://eval.contrastsecurity.com/Contrast
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

## 2. PetClinicのデプロイ
### jarの作成とDockerイメージの作成
- ビルド  
  この作業だけ、README.mdがある階層の１つ上で  
  ```bash
  # jarの作成
  mvn clean package -DskipTests
  # Dockerイメージの作成
  docker build -t petclinic_docker .
  ```
### PetClinicのデプロイ
このREADME.mdがある階層で作業します。  
- デプロイ  
  ```bash
  kubectl apply -f deployment.yaml
  # Podのステータス確認
  kubectl get pods
  ```

## 3. PetClinicへのエージェントの組み込み
```bash
kubectl apply -f - <<EOF
apiVersion: agents.contrastsecurity.com/v1beta1
kind: AgentInjector
metadata:
  name: injector-for-petclinic
  namespace: default
spec:
  type: java
  selector:
    labels:
      - name: app
        value: petclinic-agent-operator-demo
EOF
```
## 4. Contrastサーバのオンボード確認
http://localhost:30000/ に接続して適当に画面遷移してください。  
Contrastサーバにオンボードされていることを確認します。

## 後片付け
1. AgentInjectorを削除します。  
    ```bash
    kubectl -n default delete agentinjector injector-for-petclinic
    ```
2. サービスを停止します。
    ```bash
    kubectl delete -f deployment.yaml 
    ```
3. kubectlのSecretとConfigMapを削除します。 (残していても問題ないです)
    ```bash
    kubectl -n contrast-agent-operator get secrets
    kubectl -n contrast-agent-operator delete secret default-agent-connection-secret
    ```
4. Contrastエージェントオペレータの削除  
  ```bash
  kubectl delete -f https://github.com/Contrast-Security-OSS/agent-operator/releases/latest/download/install-prod.yaml
  ```

以上
