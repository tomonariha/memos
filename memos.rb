# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'cgi'

# データベースとやり取りをするクラス
class Memo
  def initialize
    @connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  end

  def all
    @connect.exec('SELECT * FROM memos ORDER BY id ASC')
  end

  def detail(id)
    @connect.exec('SELECT * FROM memos WHERE id = $1 LIMIT 1', id).first
  end

  def save(title, content)
    @connect.exec('INSERT INTO memos(title, content) VALUES ($1, $2)', [title, content])
  end

  def update(id, title, content)
    @connect.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def destroy(id)
    @connect.exec('DELETE FROM memos WHERE id = $1', id)
  end
end

memo = Memo.new

get '/memos' do
  @memos = memo.all
  @title = 'index'
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  @memo = memo.detail([params[:id]])
  @title = 'detail'
  erb :detail
end

post '/memos' do
  memo.save(params[:title], params[:content])
  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo = memo.detail([params[:id]])
  @title = 'edit'
  erb :edit
end

patch '/memos/:id' do
  memo.update(params[:id], params[:title], params[:content])
  redirect '/memos'
end

delete '/memos/:id' do
  memo.destroy([params[:id]])
  redirect '/memos'
end
