### ハンズオン

#### 1. 事前確認（10）
- Java  
`java -version`  
1.8であること
- アプリ（Jar）の確認  
  ```
  C:\contrast_training\PetClinicDemo\target
  spring-petclinic2-1.5.1.jar
  ```
- TeamServerへのログイン  
https://xxxx.contrastsecurity.com/Contrast  
userXX@ub-training.com/XXXXX

#### 2. 対象アプリケーションのオンボード（15）
- エージェントDL  
TeamServerからエージェントをDL  
`C:¥contrast_training¥PetClinicDemo`に
- アプリ起動  
  ```
  cd C:\contrast_training\PetClinicDemo
  java -javaagent:contrast.jar -Dcontrast.server.name=user05_svr -Dcontrast.agent.java.standalone_app_name=PetClinic_user05 -jar ./target/spring-petclinic-1.5.1.jar --server.port=8001
  ```
- PetClinicにアクセス  
http://localhost:8001/
- TeamServerでオンボード確認

#### 3. ASSESS（10）
- SQLインジェクション検知  
`Davis`
#### 4. PROTECT（15）
- SQLインジェクションへの攻撃（監視モード）  
`D' OR '1%'='1`
- SQLインジェクションへの攻撃（防御モード）  
`D' OR '1%'='1`

#### 5. その他
- 出力など
- ユーザー管理
- インテグレーション
- API
- ツール連携  
Eclipse, Jenkins, Maven
- マージ機能、ライセンスの付け替え

#### 6. QA
あまった時間で質疑応答

以上
