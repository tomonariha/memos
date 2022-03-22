# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'cgi'

def generate_memos
  @memos = { 'id': params['id'], 'title': params['title'], 'content': params['content'] }
end

def load_all_memos
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  @memos = connect.exec('SELECT * FROM memos ORDER BY id ASC')
end

def load_detail_memo
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  @memos = connect.exec('SELECT * FROM memos WHERE id = $1', [params[:id].to_i])
end

def save_new_memo
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  connect.exec('INSERT INTO memos(title, content) VALUES ($1, $2)', [@memos[:title], @memos[:content]])
end

def update_memo
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  connect.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3',
               [@memos[:title], @memos[:content], @memos[:id]])
end

def delete_memo
  connect = PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
  connect.exec('DELETE FROM memos WHERE id = $1', [params[:id]])
end

get '/memos' do
  load_all_memos
  @title = 'index'
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  load_detail_memo
  @title = 'detail'
  erb :detail
end

post '/memos' do
  generate_memos
  save_new_memo
  redirect '/memos'
end

get '/memos/:id/edit' do
  load_detail_memo
  @title = 'edit'
  erb :edit
end

patch '/memos/:id' do
  generate_memos
  update_memo
  redirect '/memos'
end

delete '/memos/:id' do
  delete_memo
  redirect '/memos'
end
