### PetClinicDemoを取得します。

```bash
mkdir flowmap_test
cd flowmap_test/
git clone https://github.com/turbou/PetClinicDemo.git petclinicdemo1
git clone https://github.com/turbou/PetClinicDemo.git petclinicdemo2
```

### １つめを起動

※ sh実行前にstartup_8001.shのエージェントのパスを環境に合わせてください。

```bash
cd petclinicdemo1/
# まずMySqlコンテナを起動（これは一度だけでOKです）
docker-compose up -d
# application.propertiesを入れ替え
cp src/main/resources/application_mysql1.properties src/main/resources/application.properties
# ビルド
mvn clean package -DskipTests
# 起動
./startup_8001.sh
```

〜ここでPetClinic_8001のフローマップを確認してください。〜

### ２つめを起動

※ sh実行前にstartup_8002.shのエージェントのパスを環境に合わせてください。

```bash
cd ../petclinicdemo2/
# application.propertiesを入れ替え
cp src/main/resources/application_mysql2.properties src/main/resources/application.properties
# ビルド
mvn clean package -DskipTests
# 起動
./startup_8002.sh
```

〜ここでPetClinic_8001またはPetClinic_8002のフローマップを確認してください。〜

### おまけ

#### databaseの中身確認

```bash
docker exec -it flowmap_mysql bash
mysql -u root -p
# パスワードはroot
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| petclinic1         | ★
| petclinic2         | ★
| sys                |
| test               |
+--------------------+
# petclinic1のほうを確認
mysql> use petclinic1
mysql> select * from owners;
# petclinic2のほうを確認
mysql> use petclinic2
mysql> select * from owners;
```

#### mysqlのリセット

```bash
docker-compose down
docker volume prune
# でYes
```

以上

