# CF Dev(PCF Dev)でのコントラスト導入手順

## 参考ページ

https://docs.pivotal.io/pcf-dev/index.html

https://docs.pivotal.io/pcf-dev/install-osx.html

https://qiita.com/MahoTakara/items/888ffdadbf34fd2033d6

## インストール（cf, pcf共通）

### CF CLI(Cloud Foundry Command Line Interface)のインストール

https://pivotal.io/jp/platform/pcf-tutorials/getting-started-with-pivotal-cloud-foundry/install-the-cf-cli

cf-cli-installer_6.49.0_osx.pkg をDL

```bash
(base) MacBookPro15:contrast turbou$ cf -v
cf バージョン 6.49.0+d0dfa93bb.2020-01-07
```

### PCF Devの場合

- PCF DevをDLしておく
  https://network.pivotal.io/products/pcfdev#/releases/339789
  pcfdev-v1.2.0-darwin.tgz

- セットアップ

  ```bash
  # 一応確認
  cf plugins
  # もしも同様のdev系プラグインが入っていたらアンインストール
  cf uninstall-plugin pcfdev
  # cfdevプラグインをインストール
  cf install-plugin cfdev
  cf plugins # この時だと、0.0.17
  # 起動（かなり時間かかります）
  cf dev start -m 8192 -f ./pcfdev-v1.2.0-darwin.tgz
  ```

- ログイン

  ```bash
  cf login -a https://api.dev.cfdev.sh --skip-ssl-validation
  ```

  admin/adminでログイン

- 組織、スペースの作成

  ```bash
  # 組織の作成
  cf create-org tabocom
  # スペースの作成
  cf create-space sample -o tabocom
  # ターゲットの切り替え
  cf target -o "tabocom" -s "sample"
  ```



## アプリのpush

### サンプルアプリの準備

```bash
git clone https://github.com/turbou/PetClinicDemo
cd PetClinicDemo
mvn clean package -DskipTests
```

------

### Contrast関係なくアプリをpushする場合

- manifest_apponly.yml（なければ準備してください）

  ```yaml
  ---
  applications:
  - name: petclinic
    memory: 1G
    instances: 1
    timeout: 180
    path: ./target/spring-petclinic-1.5.1.jar
    buildpacks:
    - https://github.com/cloudfoundry/java-buildpack.git
  ```

- push

  ```bash
  cf push -f manifest_apponly.yml
  ```

------

### Contrast利用でUserProvidedServiceを使用する場合

- ユーザー提供サービスの作成

  ```bash
  cf create-user-provided-service contrast-security-service -p '{"teamserver_url": "https://eval.contrastsecurity.com/Contrast/", "username": "turbou@i.softbank.jp", "api_key": "XXXK6pIuD6mh5RX6YQ2iMOOavh9MXXXX", "service_key": "XXXXXXXXXXXXXXXX"}'
  ```
  
  参考までに
  
  ```bash
    # 確認
    cf services
    # 削除
    cf unbind-service taka-petclinic contrast-security-service
    cf delete-service contrast-security-service
  ```
  
- manifest.yml

  ```yaml
  ---
  applications:
  - name: petclinic
    memory: 1G
    instances: 1
    timeout: 180
    path: ./target/spring-petclinic-1.5.1.jar
    buildpacks:
    - https://github.com/cloudfoundry/java-buildpack.git
    services:
    - contrast-security-service
    env:
      JAVA_OPTS: -Dcontrast.override.appname=PetClinicPCF1 -Dcontrast.server.name=PCF-taka1 -Dcontrast.server.environment=qa Dcontrast.agent.polling.app_activity_ms=3000 -Dcontrast.server.activity.period=3000 -Dcontrast.agent.logger.level=ERROR
  ```

- Push
  参考までに既存アプリの停止と削除

  ```bash
  cf stop petclinic
  cf delete petclinic
  ```

  ```bash
  cf push -f manifest.yml
  ```

------

### Contrast利用でcontrast.jarとcontrast_security.ymlを使う場合

contrast.jar*と*contrast_security.yamlをsrc/main/resourcesに置いてやるやり方です。

- contrast.jar*と*contrast_security.yamlをsrc/main/resourcesに配置する。

  ```yaml
  api: 
    url: https://eval.contrastsecurity.com/Contrast
    api_key: XXXK6pIuD6mh5RX6YQ2iMOOavh9McXXX
    service_key: XXXXXXXXXXXXXXXX
    user_name: agent_442311fd-XXXX-XXXX-XXXX-2b03db2d816c@Tabocom
  server:
    name: PCF-taka2
  application:
    name: PetClinicPCF2
  agent:
    logger:
      level: ERROR
    polling:
      app_activity_ms: 3000
      server_activity_ms: 3000
  ```

- 再度ビルド

  ```bash
  mvn clean package -DskipTests
  ```

- manifest_apponly.yml を使いまわします。

  ```yaml
  ---
  applications:
  - name: petclinic
    memory: 1G
    instances: 1
    timeout: 180
    path: ./target/spring-petclinic-1.5.1.jar
    buildpacks:
    - https://github.com/cloudfoundry/java-buildpack.git
  ```
  
- push
参考までに既存アプリの停止と削除
  
  ```bash
  # アプリの削除
  cf stop petclinic
  cf delete petclinic
  # サービス削除
  cf services
  cf delete-service contrast-security-service
  ```
  
  ```bash
  # 起動なしでpush
  cf push --no-start -f manifest_apponly.yml
  ```

- JAVA_OPTSをコマンドでセット

  ```bash
  cf set-env petclinic JAVA_OPTS '-javaagent:/home/vcap/app/BOOT-INF/classes/contrast.jar -Dcontrast.config.path=/home/vcap/app/BOOT-INF/classes/contrast_security.yaml'
  ```

- start

  ```bash
  cf start petclinic
  ```

------

### その他

#### スケールアウト

```bash
cf scale petclinic -i 2
```

