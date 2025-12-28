# メモアプリ
Sinatraで作ったシンプルなメモアプリです。

## 使い方
1. PostgreSQLを起動してデータベース`sinatra_memo_app`を作成
```
createdb sinatra_memo_app
```
※OSユーザ名と同じPostgreSQLロールが存在しない場合は以下を実行
```
sudo -u postgres psql
```
```
CREATE ROLE [実行ユーザ名] WITH LOGIN PASSWORD 'password';
ALTER DATABASE sinatra_memo_app OWNER TO [実行ユーザ名];
GRANT ALL ON SCHEMA public TO [実行ユーザ名];
```

2. リポジトリをクローン
```
git clone https://github.com/samovar1214/sinatra-memo-app
cd sinatra-memo-app
```

3. インストール
```
bundle install
```

4. 実行
```
bundle exec ruby app.rb
```

5. アクセス
http://localhost:4567
