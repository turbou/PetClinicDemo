# AnsibleでPetClinicをJavaエージェント付きで起動するサンプル
## 動作確認済み環境
- CentOS7
  - Python 3.6.8
  - ansible 2.11.12
- Ubuntu24
  - Python 3.12.3
  - ansible 2.17.1

## 初期セットアップ
### OSに対して
- SELinuxをdisabledにする。(CentOS)

### 必要なものをインストール
venv, pipを使ってansibleをインストールしています。

### Contrastロールを取得
```bash
# このREADMEがある場所で
mkdir roles
cd roles
# このcloneするディレクトリのcontrastは後のrole指定で使う名前となります。
git clone https://github.com/Contrast-Security-OSS/ansible-role-contrast.git contrast
```

### 新しいansibleに対応するためちょっと弄る
```bash
vim ./roles/contrast/tasks/main.yml
```
修正箇所が**２つ**あります。
1. `sudo: True`の行を削除してください。(2箇所あります)
2. get_urlの`headers`が、**dict形式（連想配列形式）** じゃないと怒られます。  
   具体的には以下の差分のように修正してください。
```
-      headers: 'Accept:application/json,API-Key:{{ contrast_api_key }},Authorization:{{ contrast_authorization_key | b64encode }}'
+      headers: 
+        Accept: "application/json"
+        API-Key: "{{ contrast_api_key }}"
+        Authorization: "{{ contrast_authorization_key | b64encode }}"
```

## Ansibleの実行
### エージェントの設定を定義する
linux.ymlの中の47行目から51行目のご使用の環境にあわせて定義してください。
### 実行する
linux.ymlでCentOS, Ubuntuのどちらでも動くようにしています。
処理の大まかな流れとしては以下のとおりです。  
1. Javaのインストール確認（バージョンまではやっていません）
2. Javaが入ってなければインストール（1.8）
3. Contrastエージェントの存在とバージョン確認
4. MavenのContrastエージェントの最新バージョンを取得
5. Contrastエージェントが存在しない、またはバージョンが古い場合は最新のContrastエージェントを取得して配置
   `/opt/contrast/contrast.jar`
7. PetClinicのjarファイルを取得
   現在は`/root/`ホーム直下です。変更する場合は`56, 73行目`を修正してください。
9. PetClinicをContrastエージェント付きで起動

```bash
ansible-playbook linux.yml
```
### 確認する
- 8001ポートでPetClinicが起動していることを確認
- TeamServerでオンボード確認

CentOSでのfirewalld、Ubuntuでのufwのポートオープンに関するplaybookは以下、参考にしてください。  
- CentOS  
  firewalld.yml
- Ubuntu  
  ufw.yml

### 起動したPetClinicの停止方法
```bash
pkill -f spring-petclinic
```

以上
