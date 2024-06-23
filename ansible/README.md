# AnsibleでPetClinicをJavaエージェント付きで起動するサンプル
## 前提条件
- CentOS7
- ansible 2.9.27

## 初期セットアップ
### OSに対して
- SELinuxをdisabledにする。

### 必要なものをインストール
- yum install epel-release
- yum install -y ansible

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
`sudo: True`の行を削除してください。

## Ansibleの実行
### エージェントの設定を定義する
sample.ymlの中の21行目から29行目のContrastロール変数を環境にあわせて定義してください。
### 実行する
```bash
ansible-playbook sample.yml
```
### 確認する
- 8001ポートでPetClinicが起動していることを確認
- TeamServerでオンボード確認

以上
