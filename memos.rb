# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'cgi'

def connect_database
  PG::Connection.new(host: 'localhost', user: 'postgres', dbname: 'memo')
end

def generate_memo(id, title, content)
  { id: id, title: title, content: content }
end

def load_all_memos(connect)
  connect.exec('SELECT * FROM memos ORDER BY id ASC')
end

def load_detail_memo(connect, id)
  connect.exec('SELECT * FROM memos WHERE id = $1', id)
end

def save_new_memo(connect, memo)
  connect.exec('INSERT INTO memos(title, content) VALUES ($1, $2)', [memo[:title], memo[:content]])
end

def update_memo(connect, memo)
  connect.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3',
               [memo[:title], memo[:content], memo[:id]])
end

def delete_memo(connect, id)
  connect.exec('DELETE FROM memos WHERE id = $1', id)
end

get '/memos' do
  connection = connect_database
  @memos = load_all_memos(connection)
  @title = 'index'
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

get '/memos/:id' do
  connection = connect_database
  @memo = load_detail_memo(connection, [params[:id]])
  @title = 'detail'
  erb :detail
end

post '/memos' do
  connection = connect_database
  memo = generate_memo([params[:id]], params[:title], params[:content])
  save_new_memo(connection, memo)
  redirect '/memos'
end

get '/memos/:id/edit' do
  connection = connect_database
  @memo = load_detail_memo(connection, [params[:id]])
  @title = 'edit'
  erb :edit
end

patch '/memos/:id' do
  connection = connect_database
  memo = generate_memo(params[:id], params[:title], params[:content])
  update_memo(connection, memo)
  redirect '/memos'
end

delete '/memos/:id' do
  connection = connect_database
  delete_memo(connection, [params[:id]])
  redirect '/memos'
end
