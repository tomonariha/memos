# このアプリについて
- 簡単なメモを記録・表示するWEBアプリケーションです。
# 使い方
1. 右上の`Fork`ボタンを押し、memosリポジトリを自分のリポジトリにコピーします。
1. `git clone`でmemosを任意のディレクトリにコピーします。
1. コマンドラインを起動して`gem install bundler`を実行し、bundrerをインストールします。
1. memosディレクトリに移動して`bundle install`を実行し、Gemfileに書いてあるsinatra、sinatra-contribのgemをインストールします。
1. memosディレクトリでruby memos.rbを実行し、Sinatraを起動します。
1. ブラウザで<http://localhost:4567/memos>にアクセスします。
1. `追加`でメモを新しく作り投稿します。
1. インデックスでメモのタイトルをクリックすると内容が表示されます。
また、メモの内容の変更や削除が行えます。
1. 終了するときは、コマンドライン上でコントロールキー+Cキーを押し、Sinatraを終了します。
