# このアプリについて
- 簡単なメモを記録・表示するWEBアプリケーションです。
# 使い方
1. `git clone (https://github.com/tomonariha/memos)`でmemosを任意のディレクトリにコピーします。
1. コマンドラインを起動して`gem install bundler`を実行し、bundrerをインストールします。
1. PostgreSQLをインストールします。
1. PostgreSQLに接続し、`CREATE DATABASE MEMOS;`でデータ保存用のDBを作ります。
1. 作ったデータベース(MEMOS)に移動し、以下のDDL文を実行しデータ保存用のテーブルを作ります。
``` 
CREATE TABLE MEMOS (MEMO_ID INTEGER NOT NULL, TITLE VARCHER(20), CONTENT VARCHAR(100), PRIMARY KEY (MEMO_ID));
```
1. `bundle install`を実行し、sinatra、sinatra-contrib,pgのgemをインストールします。
1. ruby memos.rbを実行し、Sinatraを起動します。
1. ブラウザで<http://localhost:4567/memos>にアクセスします。
1. `追加`でメモを新しく作り投稿します。
1. インデックスでメモのタイトルをクリックすると内容が表示されます。
また、メモの内容の変更や削除が行えます。
1. 終了するときは、コマンドライン上でコントロールキー+Cキーを押し、Sinatraを終了します。
